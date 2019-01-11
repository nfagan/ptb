classdef Generator < ptb.XYSource
  
  properties (Access = public)
    %   SETTABLEX -- X component, settable by the user.
    %
    %     SettableX is a double scalar giving the current x position, and
    %     is settable by the user.
    %
    %     See also ptb.sources.Generator, ptb.sources.Generator.SettableY
    SettableX = nan;
    
    %   SETTABLEX -- Y component, settable by the user.
    %
    %     SettableY is a double scalar giving the current y position, and
    %     is settable by the user.
    %
    %     See also ptb.sources.Generator, ptb.sources.Generator.X
    SettableY = nan;
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
      %     See also ptb.sources.Generator.SettableX, ptb.XYSource
    end
    
    function set_coordinate(obj, x, y)
      
      %   SET_COORDINATE -- Update x and y values at once.
      %
      %     See also ptb.sources.Generator
      %
      %     IN:
      %       - `x` (double)
      %       - `y` (double)
      
      obj.SettableX = x;
      obj.SettableY = y;
    end
    
    function set.SettableX(obj, v)
      validateattributes( v, {'numeric'}, {'scalar'}, mfilename, 'SettableX' );
      obj.SettableX = v;
    end
    
    function set.SettableY(obj, v)
      validateattributes( v, {'numeric'}, {'scalar'}, mfilename, 'SettableY' );
      obj.SettableY = v;
    end
  end
  
  methods (Access = protected)
    function tf = new_sample_available(obj)
      tf = true;
    end
    
    function [x, y, success] = get_latest_sample(obj)
      x = obj.SettableX;
      y = obj.SettableY;
      success = true;
    end
  end
  
end