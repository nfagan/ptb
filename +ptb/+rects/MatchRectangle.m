classdef MatchRectangle < ptb.RectPrimitive
  
  properties (Access = public)
    %   RECTANGLE -- Rectangle object defining the underlying bounds-rect.
    %
    %     Rectangle is a handle to a (non-ptb-prefixed) Rectangle object
    %     from which the base rect will be drawn, or else a
    %     ptb.stimuli.Rectangle object.
    %
    %     Rectangle can also be set to the empty matrix ([]), in which case
    %     the base rect is a vector of NaN.
    %
    %     See also ptb.rects.MatchRectangle, ptb.XYBounds
    Rectangle;
  end
  
  methods
    function obj = MatchRectangle(r)
      
      %   MATCHRECTANGLE -- Use rect drawn from rectangle stimulus.
      %
      %     obj = ptb.rects.MatchRectangle( r ); constructs an object
      %     whose get() method returns the bounding rect of `r`, a
      %     Rectangle or ptb.stimuli.Rectangle object.
      %
      %     See also ptb.stimuli.Rectangle, Rectangle, 
      %       ptb.rects.MatchRectangle.get
      
      if ( nargin < 1 )
        r = [];
      end
      
      obj = obj@ptb.RectPrimitive();
      
      obj.Rectangle = r;
    end
    
    function obj = set.Rectangle(obj, v)
      if ( isempty(v) )
        obj.Rectangle = [];
      else
        validateattributes( v, {'Rectangle', 'ptb.stimuli.Rect'} ...
          , {'scalar'}, mfilename, 'Rectangle' );
        obj.Rectangle = v;
      end
    end
  end
  
  methods (Access = public)
    function r = get(obj)
      
      %   GET -- Get rect.
      %
      %     get( obj ) returns the bounding rect of the underlying
      %     Rectangle object in `obj`, if the Rectangle property is
      %     non-empty. Otherwise, the bounding rect is a 4-element vector
      %     of NaN.
      %
      %     See also ptb.rects.MatchRectangle, ptb.stimuli.Rectangle, 
      %       Rectangle
      
      if ( isempty(obj.Rectangle) )
        r = nan( 1, 4 );
      elseif ( isa(obj.Rectangle, 'Rectangle') )
        r = obj.Rectangle.vertices;
      else
        r = get_rect( obj.Rectangle );
      end
    end
  end
end