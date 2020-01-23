classdef SingleScanOutput < handle
  properties (Access = private)
    session;
  end
  
  properties (Access = public)
    DefaultOuputValues;
  end
  
  properties (SetAccess = private, GetAccess = public)
    PendingOutputValues;
    NumOutputChannels;
  end
  
  methods
    function obj = SingleScanOutput(session)
      validateattributes( session, {'daq.Session'}, {'scalar'} ...
        , mfilename, 'session' );
      obj.session = session;
      obj.DefaultOuputValues = make_default_output_values( obj );
      obj.PendingOutputValues = obj.DefaultOuputValues;
      obj.NumOutputChannels = num_channels( obj );
    end
    
    function set.DefaultOuputValues(obj, v)
      num_chans = num_channels( obj );
      validateattributes( v, {'double'}, {'numel', num_chans, 'finite', 'nonnan'} ...
        , mfilename, 'DefaultOuputValues' );
      obj.DefaultOuputValues = v(:)';
    end
    
    function queue_value(obj, channel, value)
      validate_scalar_channel_and_value( obj, channel, value );
      obj.PendingOutputValues(channel) = value;
    end
    
    function write_value(obj, channel, value)
      queue_value( obj, channel, value );
      update( obj );
    end
    
    function update(obj)
      outputSingleScan( obj.session, obj.PendingOutputValues );
      obj.PendingOutputValues = obj.DefaultOuputValues;
    end
    
    function validate_scalar_channel_and_value(obj, channel, value)
      validate_channel_index( obj, channel );
      
      if ( ~isscalar(value) )
        error( 'Value must be scalar.' );
      end
    end
    
    function validate_channel_index(obj, channel)
      if ( channel > obj.NumOutputChannels || channel < 1 )
        error( 'Channel %d is out of bounds of the number of channels (%d)' ...
          , channel, obj.NumOutputChannels );
      end
    end
    
    function delete(obj)
      try
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