classdef XYAnalogInput < ptb.XYSource
  properties (Access = private)
    source;
    x_interval;
    y_interval;
  end
  
  properties (Access = public)
    %   CALIBRATIONRECT -- Screen rect to which the eyetracker was calibrated.
    %
    %     See also ptb.sources.XYAnalogInput
    CalibrationRect = ptb.Rect.Configured( 'IsNonNan', true );
    
    %   CHANNELMAPPING -- Mapping of analog input channels to x, y, pupil signals.
    %
    %     ChannelMapping is a 3-element vector giving indices into the set 
    %     of active analog input channels in the current DAQ session that
    %     correspond to the eyetracker's x, y, and pupil size outputs, 
    %     respectively. By default, these are assumed to be the first 3 
    %     input channels.
    %
    %     See also ptb.sources.XYAnalogInput
    ChannelMapping = [1, 2, 3];
    
    %   OUTPUTVOLTAGELIMITS -- Ouput voltage range from the eyetracker.
    %
    %     See also ptb.sources.XYAnalogInput
    OutputVoltageRange = [-5, 5];
  end
  
  methods
    function obj = XYAnalogInput(source, calibration_rect, channel_mapping)
      
      %   XYANALOGOUTPUT -- Create XY analog source object instance.
      %
      %     obj = ptb.sources.XYAnalogInput( source ); creates an
      %     interface for obtaining (X, Y) gaze position samples from the
      %     analog output of an eyetracker. Raw voltage data come from 
      %     `source`, a ptb.signal.SingleScanInput object.
      %
      %     obj = ptb.sources.XYAnalogInput( ..., calibration_rect );
      %     sets the CalibrationRect property to `calibration_rect`, a
      %     4-element vector or ptb.Rect object representing the screen
      %     rect to which the eyetracker was calibrated.
      %
      %     obj = ptb.sources.XYAnalogInput( ..., channel_mapping );
      %     sets the ChannelMapping property to `channel_mapping`, a
      %     3-element vector giving the indices into the set of active 
      %     analog input channels in the current DAQ session that 
      %     correspond to the eye tracker's x, y, and possibly pupil size 
      %     outputs. By default, these are assumed to be the first 3 input 
      %     channels.
      %
      %     See also ptb.XYSource, ptb.signal.SingleScanInput
      
      obj = obj@ptb.XYSource();
      obj.source = source;
      
      if ( nargin > 1 )
        obj.CalibrationRect = calibration_rect;
      end
      if ( nargin > 2 )
        obj.ChannelMapping = channel_mapping;
      end
      
      compute_intervals( obj );
    end
    
    function set.source(obj, v)
      validateattributes( v, {'ptb.signal.SingleScanInput'}, {'scalar'} ...
        , mfilename, 'source' );
      obj.source = v;
    end
    
    function set.CalibrationRect(obj, v)
      obj.CalibrationRect = set( obj.CalibrationRect, v );
      compute_intervals( obj );
    end
    
    function set.ChannelMapping(obj, v)
      validateattributes( v, {'double'} ...
        , {'nonnan', 'finite', 'integer', 'positive'}, mfilename ...
        , 'ChannelMapping' );
      
      if ( numel(v) < 2 || numel(v) > 3 )
        error( 'ChannelMapping must be a 2 or 3-element vector.' );
      end
      
      v = v(:)';
      
      if ( numel(v) < 3 )
        obj.ChannelMapping = [v, 1];
      elseif ( numel(v) > 3 )
        obj.ChannelMapping = v(1:3);
      else
        obj.ChannelMapping = v;
      end
    end
    
    function set.OutputVoltageRange(obj, v)
      ptb.util.LinearlyMappedInterval.validate_range( v, 'OutputVoltageRange' );
      obj.OutputVoltageRange = v;
      
      compute_intervals( obj );
    end
  end
  
  methods (Access = private)
    function compute_intervals(obj)
      import ptb.util.LinearlyMappedInterval;
      
      x_range = [ obj.CalibrationRect.X1, obj.CalibrationRect.X2 ];
      y_range = [ obj.CalibrationRect.Y1, obj.CalibrationRect.Y2 ];
      
      obj.x_interval = LinearlyMappedInterval( obj.OutputVoltageRange, x_range );
      obj.y_interval = LinearlyMappedInterval( obj.OutputVoltageRange, y_range );
    end
  end
  
  methods (Access = protected)
    function tf = new_sample_available(obj)
      % New sample is always available.
      tf = true;
    end
    
    function [x, y, success] = get_latest_sample(obj)
      data = get_latest_sample( obj.source );
      
      if ( numel(data) < 2 )
        error( ['Expected data from at least 2 active analog input channels,' ...
          , ' but received %d samples.'], numel(data) );
        
      elseif ( any(obj.ChannelMapping > numel(data)) )
        error( ['An element of `ChannelMapping` is larger than the number' ...
          , ' of active analog input channels.'] );
      end
      
      raw_x = data(obj.ChannelMapping(1));
      raw_y = data(obj.ChannelMapping(2));
      
      x = apply( obj.x_interval, raw_x );
      y = apply( obj.y_interval, raw_y );
      success = true;
    end
  end
end