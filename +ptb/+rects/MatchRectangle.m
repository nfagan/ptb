classdef MatchRectangle < ptb.RectPrimitive
  
  properties (Access = public)
    %   RECTANGLE -- Rectangle object defining the underlying bounds-rect.
    %
    %     Rectangle is a handle to a (non-ptb-prefixed) Rectangle object
    %     from which the base rect will be drawn, or else a
    %     ptb.stimuli.Rect object.
    %
    %     Rectangle can also be set to the empty matrix ([]), in which case
    %     the base rect is a vector of NaN.
    %
    %     See also ptb.rects.MatchRectangle, ptb.XYBounds
    Rectangle = ptb.Null;
  end
  
  methods
    function obj = MatchRectangle(r)
      
      %   MATCHRECTANGLE -- Use rect drawn from rectangle stimulus.
      %
      %     obj = ptb.rects.MatchRectangle( r ); constructs an object
      %     whose get() method returns the bounding rect of `r`, a
      %     Rectangle or ptb.stimuli.Rect object.
      %
      %     See also ptb.stimuli.Rect, Rectangle, ptb.rects.MatchRectangle.get
      
      if ( nargin < 1 )
        r = ptb.Null();
      end
      
      obj = obj@ptb.RectPrimitive();
      
      obj.Rectangle = r;
    end
    
    function obj = set.Rectangle(obj, v)
      validateattributes( v, {'Rectangle', 'ptb.stimuli.Rect', 'ptb.Null'} ...
        , {'scalar'}, mfilename, 'Rectangle' );
      obj.Rectangle = v;
    end
  end
  
  methods (Access = public)
    function r = get_window_dependent(obj, window)
      
      %   GET_WINDOW_DEPENDENT -- Get rect, possibly using the specified
      %     window.
      %
      %     See also ptb.RectPrimitive
      
      if ( isa(obj.Rectangle, 'ptb.stimuli.Rect') )
        r = get_rect( obj.Rectangle, window );
      else
        r = get( obj );
      end
    end
    
    function r = get(obj)
      
      %   GET -- Get rect.
      %
      %     get( obj ) returns the bounding rect of the underlying
      %     Rectangle object in `obj`, if the Rectangle property is
      %     non-empty. Otherwise, the bounding rect is a 4-element vector
      %     of NaN.
      %
      %     See also ptb.rects.MatchRectangle, ptb.stimuli.Rect, 
      %       Rectangle
      
      if ( ptb.isnull(obj.Rectangle) )
        r = nan( 1, 4 );
      elseif ( isa(obj.Rectangle, 'Rectangle') )
        r = obj.Rectangle.vertices;
      else
        r = get_rect( obj.Rectangle );
      end
    end
  end
end