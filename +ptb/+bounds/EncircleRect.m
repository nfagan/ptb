classdef EncircleRect < ptb.bounds.CirclePrimitive
  
  properties (Access = public)
    %   WINDOW -- Window with which to interpret units of Padding
    %
    %     Window is a ptb.Window object giving the window to which non-px
    %     units of Padding will be referenced. For example, if the units of 
    %     Padding are 'normalized', then the value of Padding will be 
    %     normalized to the pixel width of the window.
    %
    %     Window can also be a ptb.Null object, representing the absence of
    %     a window. In this case, if the units of Padding are not 'px', 
    %     its value is NaN.
    %
    %     See also ptb.bounds.EncircleRect,
    %       ptb.bounds.EncircleRect.BaseRect
    Window = ptb.Null;
    
    %   BASERECT -- Base bounds-rect.
    %
    %     BaseRect is an object that defines the bounding rect that should
    %     be enclosed by the circular bounds.
    %
    %     See also ptb.Rect, ptb.bounds.Rect
    BaseRect = ptb.Null;
    
    %   PADDING -- Padding to be applied to the circle's radius.
    %
    %     Padding is a ptb.Transform object representing an amount of
    %     padding that should be applied to the radius of the bounding
    %     circle. Values larger than 0 expand the bounding circle.
    Padding = ptb.Transform.OneDimensional();
  end
  
  methods
    function obj = EncircleRect(base_rect)
      
      %   ENCIRCLERECT -- Create bounds that encircle a rect.
      %
      %     obj = ptb.bounds.EncircleRect() creates an object that tests 
      %     whether an (X, Y) coordinate is in bounds of the smallest
      %     circle enclosing a bounding rect. The BaseRect property is set
      %     to a Null value, meaning that the object's `test` method will
      %     always return false.
      %
      %     obj = ptb.bounds.EncircleRect( base_rect ) uses the
      %     bounding-rect given by `base_rect`, a ptb.RectPrimitive object
      %     such as a ptb.Rect.
      %
      %     See also ptb.Rect, ptb.bounds.Circle, ptb.XYBounds
      
      obj = obj@ptb.bounds.CirclePrimitive();
      
      if ( nargin == 1 )
        obj.BaseRect = base_rect;
      end
    end
    
    function set.Padding(obj, v)
      obj.Padding = set( obj.Padding, v );
    end
    
    function set.BaseRect(obj, v)
      classes = { 'ptb.RectPrimitive', 'ptb.Null' };
      validateattributes( v, classes, {'scalar'}, mfilename, 'BaseRect' );
      obj.BaseRect = v;      
    end
    
    function set.Window(obj, v)
      classes = { 'ptb.Window', 'ptb.Null' };
      validateattributes( v, classes, {'scalar'}, mfilename, 'Window' );
      obj.Window = v;
    end
  end
  
  methods (Access = public)
    
    function draw(obj, window, varargin)
      if ( nargin < 2 )
        window = obj.Window;
      end
      
      draw@ptb.bounds.CirclePrimitive( obj, window, varargin{:} );
    end
  end
  
  methods (Access = protected)
    function [center, w, h] = get_center(obj)
      if ( ptb.isnull(obj.BaseRect) )
        center = nan( 1, 2 );
        return
      end
      
      [x1, y1, w, h] = get_decomposed_rect( obj );
      
      cx = x1 + w/2;
      cy = y1 + h/2;
      
      center = [ cx, cy ];
    end
    
    function radius = get_radius(obj)
      if ( ptb.isnull(obj.BaseRect) )
        radius = nan;
        return
      end
      
      [center, w, h] = get_center( obj );
      
      x2 = center(1) + w/2;
      y2 = center(2) + h/2;
      
      % Distance between center and corner of rect
      base_radius = ptb.util.distance( center(1), center(2), x2, y2 );
      
      radius = base_radius + get_pixel_value( obj.Padding, obj.Window );            
    end
  end
  
  methods (Access = private)
    function [x1, y1, w, h] = get_decomposed_rect(obj)
      rect = get( obj.BaseRect );
      
      x1 = rect(1);
      y1 = rect(2);
      
      w = rect(3) - x1;
      h = rect(4) - y1;
    end
  end
end