classdef SingleScanOutputPulseManager < handle
  properties (Access = private)
    scan_output;
    channel_index;
    
    active_pulse_timer;
    active_pulse_time;
    
    pending_pulse_times;
  end
  
  properties (Access = public)
    
    %   LOW -- Low value written upon pulse terminaton.
    %
    %     See also ptb.signal.AnalogOutputPulseManager, 
    %       ptb.signal.AnalogOutputPulseManager.High
    Low = 0;
    
    %   HIGH -- High value written upon pulse onset.
    %
    %     See also ptb.signal.AnalogOutputPulseManager, 
    %       ptb.signal.AnalogOutputPulseManager.Low
    High = 5;
  end
  
  methods
    function obj = SingleScanOutputPulseManager(scan_output, channel_index)
      
      %   SINGLESCANOUTPUTPULSEMANAGER -- Create pulse manager instance.
      %
      %     obj = ptb.signal.SingleScanOutputPulseManager( 
      %       single_scan_output, channel_index 
      %     );
      %     instantiates an interface for writing timed pulses to a DAQ
      %     session output. `single_scan_output` is a
      %     ptb.signal.SingleScanOutput object representing the set of
      %     single scan output channels in the current DAQ session, and
      %     `channel_index` is the 1-based index into that channel set.
      %
      %     See also ptb.signal.SingleScanOutputPulseManager.trigger,
      %       ptb.signal.SingleScanOutputPulseManager.update,
      %       ptb.signal.SingleScanOutput
      
      validateattributes( scan_output, {'ptb.signal.SingleScanOutput'} ...
        , {'scalar'}, mfilename, 'scan_output' );
      
      validate_channel_index( scan_output, channel_index );
      
      obj.scan_output = scan_output;
      obj.channel_index = channel_index;
    end
    
    function set.Low(obj, v)
      validate_voltage( obj, v, 'Low' );
      obj.Low = v;
    end
    
    function set.High(obj, v)
      validate_voltage( obj, v, 'High' );
      obj.High = v;
    end
    
    function update(obj) 
      
      %   UPDATE -- Update active and pending pulses.
      %
      %     update( obj ); considers pending and active pulses. If the 
      %     active pulse has elapsed, it is terminated by writing Low to 
      %     the output. If a pending pulse exists, it is made active by
      %     writing High to the output and removed from the queue.
      %
      %     See also ptb.signal.SingleScanOutputPulseManager
      
      if ( ~isempty(obj.active_pulse_timer) )
        if ( elapsed_active(obj) )
          write_low_clear_active( obj );
        else
          queue_write_high( obj );
        end
      end
      
      if ( ~isempty(obj.active_pulse_timer) || isempty(obj.pending_pulse_times) )
        return;
      end
      
      write_high_activate( obj, obj.pending_pulse_times(1) );      
      obj.pending_pulse_times(1) = [];
    end
    
    function trigger(obj, pulse_time)
      
      %   TRIGGER -- Trigger pulse, or queue it if an active pulse exists.
      %
      %     trigger( obj, pulse_time ), when there are no active or pending
      %     pulses, immediately writes High to the output, and returns. In
      %     subsequent calls to `update`, Low will be written to the output
      %     once `pulse_time` seconds have elapsed.
      %
      %     trigger( obj, pulse_time ), when there are active or pending
      %     pulses, adds the pulse to the queue. In subsequent calls to
      %     `update`, the pulse will be triggered once all pending pulses
      %     have been triggered.
      %
      %     See also ptb.signal.SingleScanOutputPulseManager,
      %       ptb.signal.SingleScanOutputPulseManager.update
      
      if ( isempty(obj.pending_pulse_times) && elapsed_active(obj) )        
        write_high_activate( obj, pulse_time );
      else
        obj.pending_pulse_times(end+1) = pulse_time;
      end
    end
    
    function delete(obj)
      try
        write_low_clear_active( obj );
      catch err
        warning( err.message );
      end
    end
  end
  
  methods (Access = private)
    function validate_voltage(obj, v, name)
      validateattributes( v, {'double'}, {'scalar', 'nonnan', 'finite'} ...
        , mfilename, name );
    end
    
    function tf = elapsed_active(obj)
      tf = isempty( obj.active_pulse_timer ) || ...
        toc( obj.active_pulse_timer ) >= obj.active_pulse_time;
    end
    
    function queue_write_high(obj)
      queue_value( obj.scan_output, obj.channel_index, obj.High );
    end
    
    function write_low_clear_active(obj)
      write_value( obj.scan_output, obj.channel_index, obj.Low );
      obj.active_pulse_timer = [];
      obj.active_pulse_time = nan;
    end
    
    function write_high_activate(obj, pulse_time)
      write_value( obj.scan_output, obj.channel_index, obj.High );
      obj.active_pulse_timer = tic();
      obj.active_pulse_time = pulse_time;
    end
  end
end