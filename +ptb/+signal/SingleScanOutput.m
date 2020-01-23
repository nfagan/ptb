classdef SingleScanOutput < handle
  properties (Access = private)
    session;
  end
  
  properties (Access = public)
    
    %   DEFAULTOUTPUTVALUES -- Default values to be written each frame.
    %
    %     DefaultOutputValues is a 1xN vector of default values for each of
    %     N output channels. If PersistOutputValues is false, then, each 
    %     frame, the value of each channel will be reset to its 
    %     corresponding entry in DefaultOutputValues.
    %
    %     See also ptb.signal.SingleScanOutput.PersistOutputValues,
    %       ptb.signal.SingleScanOutput
    DefaultOuputValues;
    
    %   PERSISTOUTPUTVALUES -- True if output values persist once set.
    %
    %     PersistOutputValues is a logical scalar indicating whether a
    %     value written to a channel on a given frame should retain that
    %     value until explicitly set to a different value. If false, then
    %     the value of each channel will be reset to its respective
    %     default at the end of the frame.
    %
    %     See also ptb.signal.SingleScanOutput.DefaultOutputValues,
    %       ptb.signal.SingleScanOutput
    PersistOutputValues;
  end
  
  properties (SetAccess = private, GetAccess = public)
    
    %   PENDINGOUTPUTVALUES -- Values to be written next frame.
    %
    %     PendingOutputValues is a 1xN read-only array of values for each 
    %     of N channels to be written on the next call to `update`.
    %
    %     See also ptb.signal.SingleScanOutput.PersistOutputValues,
    %       ptb.signal.SingleScanOutput
    PendingOutputValues;
    
    %   NUMOUTPUTCHANNELS -- Number of output channels in the DAQ session.
    %
    %     See also ptb.signal.SingleScanOutput
    NumOutputChannels;
  end
  
  methods
    function obj = SingleScanOutput(session)
      
      %   SINGLESCANOUTPUT -- Create SingleScanOutput object instance.
      %
      %     obj = ptb.signal.SingleScanOutput( session ); instantiates an
      %     interface for writing data to all outputs of a DAQ `session` in 
      %     an immediate-mode / on-demand fashion. That is, values are only
      %     output upon an explicit call to an `update` function.
      %
      %     See also ptb.signal.SingleScanInput.queue_value,
      %       ptb.signal.SingleScanInput.write_value,
      %       ptb.signal.SingleScanInput.update
      
      validateattributes( session, {'daq.Session'}, {'scalar'} ...
        , mfilename, 'session' );
      obj.session = session;
      obj.DefaultOuputValues = make_default_output_values( obj );
      obj.PendingOutputValues = obj.DefaultOuputValues;
      obj.NumOutputChannels = num_channels( obj );
      obj.PersistOutputValues = false;
    end
    
    function set.DefaultOuputValues(obj, v)
      num_chans = num_channels( obj );
      validateattributes( v, {'double'}, {'numel', num_chans, 'finite', 'nonnan'} ...
        , mfilename, 'DefaultOuputValues' );
      obj.DefaultOuputValues = v(:)';
    end
    
    function set.PersistOutputValues(obj, v)
      validateattributes( v, {'logical'}, {'scalar'}, mfilename, 'PersistOutputValues' );
      obj.PersistOutputValues = v;
    end
    
    function queue_value(obj, channel, value)
      
      %   QUEUE_VALUE -- Set a channel's value to be written this frame.
      %
      %     queue_value( obj, channel, value ); sets the entry of 
      %     PersistOutputValues corresponding to `channel` to `value`, but
      %     does not write the value to the output.
      %
      %     See also ptb.signal.SingleScanOutput,
      %       ptb.signal.SingleScanOutput.write_value,
      %       ptb.signal.SingleScanOutput.update
      
      validate_scalar_channel_and_value( obj, channel, value );
      obj.PendingOutputValues(channel) = value;
    end
    
    function write_value(obj, channel, value)
      
      %   WRITE_VALUE -- Queue value and write to the output.
      %
      %     write_value( obj, channel, value ); sets the entry of 
      %     PendingOutputValues corresponding to `channel` to `value`, and
      %     then immediately calls `update`, such that the value is written
      %     immediately.
      %
      %     See also ptb.signal.SingleScanOutput,
      %       ptb.signal.SingleScanOutput.queue_value, 
      %       ptb.signal.SingleScanOutput.update
      
      queue_value( obj, channel, value );
      update( obj );
    end
    
    function update(obj)
      
      %   UPDATE -- Write pending values to the output.
      %
      %     update( obj ); writes the values in PendingOutputValues to the
      %     output. If PersistOutputValues is false, then all 
      %     PendingOutputValues are immediately reset to their
      %     DefaultOutputValues. Otherwise, they retain the same value.
      %
      %     See also ptb.signal.SingleScanOutput,
      %       ptb.signal.SingleScanOutput.write_value, 
      %       ptb.signal.SingleScanOutput.update
      
      outputSingleScan( obj.session, obj.PendingOutputValues );
      
      if ( ~obj.PersistOutputValues )
        obj.PendingOutputValues = obj.DefaultOuputValues;
      end
    end
    
    function validate_scalar_channel_and_value(obj, channel, value)
      
      %   VALIDATE_SCALAR_CHANNEL_AND_VALUE -- Ensure valid channel and value.
      %
      %     validate_scalar_channel_and_value( obj, channel, value );
      %     throws an error if `channel` or `value` are non-scalar, or if
      %     `channel` is out of bounds of the number of output channels in
      %     the DAQ session.
      %
      %     See also ptb.signal.SingleScanOutput
      
      validate_channel_index( obj, channel );
      
      if ( ~isscalar(value) )
        error( 'Value must be scalar.' );
      end
    end
    
    function validate_channel_index(obj, channel)
      if ( channel > obj.NumOutputChannels || channel < 1 )
        error( 'Channel %d is out of bounds of the number of channels (%d).' ...
          , channel, obj.NumOutputChannels );
      end
    end
    
    function delete(obj)
      try
        %   Reset values to their defaults before updating.
        obj.PendingOutputValues = obj.DefaultOuputValues;
        update( obj );
      catch err
        warning( err.message );
      end
    end
  end
  
  methods (Access = private)    
    function vs = make_default_output_values(obj)
      vs = zeros( 1, num_channels(obj) );
    end
    
    function n = num_channels(obj)
      channels = obj.session.Channels;
      ids = arrayfun( @(x) x.ID, channels, 'un', 0 );
      n = sum( contains(ids, 'ao') );
    end
  end
end