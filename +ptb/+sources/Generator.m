classdef Generator < ptb.XYSource
  
  properties (Access = public)
    %   SETTABLEX -- X component, settable by the user.
    %
    %     SettableX is a double scalar giving the current x position, and
    %     is settable by the user.
    %
    %     See also ptb.sources.Generator, ptb.sources.Generator.SettableY,
    %       ptb.sources.Generator.SettableIsValidSample
    SettableX = nan;
    
    %   SETTABLEX -- Y component, settable by the user.
    %
    %     SettableY is a double scalar giving the current y position, and
    %     is settable by the user.
    %
    %     See also ptb.sources.Generator, ptb.sources.Generator.X
    SettableY = nan;
    
    %   SETTABLEISVALIDSAMPLE -- IsValidSample, settable by the user.
    %
    %     SettableIsValidSample is a logical scalar indicating whether the
    %     current SettableX and SettableY components are valid.
    %
    %     See also ptb.sources.Generator, ptb.sources.Generator.X
    SettableIsValidSample = false;
  end
  
  methods
    function obj = Generator()
      
      %   GENERATOR -- Create XYSource with settable X and Y components.
      %
      %     obj = ptb.sources.Generator(); creates an XYSource object whose
      %     X and Y coordinates are settable by the user. This is useful as
      %     a debugging tool, or else in a situation when coordinates need
      %     to be generated programatically (i.e., rather than by a mouse
      %     or eye tracker).
      %
      %     See also ptb.sources.Generator.SettableX, ptb.XYSource,
      %       ptb.sources.Generator.SettableIsValidSample
      
      obj = obj@ptb.XYSource();
    end
    
    function set_coordinate(obj, x, y, is_valid_sample)
      
      %   SET_COORDINATE -- Update x and y values at once.
      %
      %     set_coordinate( obj, x, y ); sets the SettableX and SettableY
      %     properties to `x` and `y`, respectively, and indicates that
      %     this sample is valid.
      %
      %     set_coordinate( ..., is_valid_sample ) indicates whether the
      %     coordinate is considered valid.
      %
      %     See also ptb.sources.Generator
      %
      %     IN:
      %       - `x` (double)
      %       - `y` (double)
      %       - `success` (logical)
      
      if ( nargin < 4 )
        is_valid_sample = true;
      end
      
      obj.SettableX = x;
      obj.SettableY = y;
      obj.SettableIsValidSample = is_valid_sample;
    end
    
    function set.SettableX(obj, v)
      validateattributes( v, {'numeric'}, {'scalar'}, mfilename, 'SettableX' );
      obj.SettableX = v;
    end
    
    function set.SettableY(obj, v)
      validateattributes( v, {'numeric'}, {'scalar'}, mfilename, 'SettableY' );
      obj.SettableY = v;
    end
    
    function set.SettableIsValidSample(obj, v)
      validateattributes( v, {'numeric', 'logical'}, {'scalar'} ...
        , mfilename, 'SettableIsValidSample' );
      obj.SettableIsValidSample = logical( v );
    end
  end
  
  methods (Access = protected)
    function tf = new_sample_available(obj)
      tf = true;
    end
    
    function [x, y, success] = get_latest_sample(obj)
      x = obj.SettableX;
      y = obj.SettableY;
      success = obj.SettableIsValidSample;
    end
  end
  
end