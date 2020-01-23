classdef AnalogOutputPulseManager < handle
  properties (Access = private)
    scan_output;
    channel_index;
    
    active_pulse_timer;
    active_pulse_time;
    
    pending_pulse_times;
  end
  
  properties (Access = public)
    VoltageLow = 0;
    VoltageHigh = 5;
  end
  
  methods
    function obj = AnalogOutputPulseManager(scan_output, channel_index)
      validateattributes( scan_output, {'ptb.signal.SingleScanOutput'}, {'scalar'} ...
        , mfilename, 'scan_output' );
      
      validate_channel_index( scan_output, channel_index );
      
      obj.scan_output = scan_output;
      obj.channel_index = channel_index;
    end
    
    function update(obj) 
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
    function tf = elapsed_active(obj)
      tf = isempty( obj.active_pulse_timer ) || ...
        toc( obj.active_pulse_timer ) >= obj.active_pulse_time;
    end
    
    function queue_write_high(obj)
      queue_value( obj.scan_output, obj.channel_index, obj.VoltageHigh );
    end
    
    function write_low_clear_active(obj)
      write_value( obj.scan_output, obj.channel_index, obj.VoltageLow );
      obj.active_pulse_timer = [];
      obj.active_pulse_time = nan;
    end
    
    function write_high_activate(obj, pulse_time)
      write_value( obj.scan_output, obj.channel_index, obj.VoltageHigh );
      obj.active_pulse_timer = tic();
      obj.active_pulse_time = pulse_time;
    end
  end
end