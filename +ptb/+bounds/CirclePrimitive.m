classdef CirclePrimitive < ptb.XYBounds
  
  methods
    function obj = CirclePrimitive()
      obj = obj@ptb.XYBounds();
    end
  end
  
  methods (Access = public)
    function tf = test(obj, x, y)
      
      %   TEST -- Test if (X, Y) coordinate is in bounds of circle.
      %
      %     tf = test( obj, x, y ); returns true if the scalar coordinate
      %     given by (x, y) lies within the circular bounds of `obj`.
      %
      %     See also ptb.XYBounds, ptb.bounds.CirclePrimitive
      
      center = get_center( obj );
      radius = get_radius( obj );
      
      x2 = center(1);
      y2 = center(2);
      
      tf = ptb.util.distance( x, y, x2, y2 ) < radius;
    end
    
    function draw(obj, window, color)
      
      %   DRAW -- Draw outline of circle bounds.
      %
      %     draw( obj, window ); draws an outline of the circle bounds in
      %     `obj` into `window`, a ptb.Window object.
      %
      %     draw( obj, window, color ); uses `color` to style the outline.
      %     `color` is a 3- or 4-element vector.
      %
      %     See also ptb.bounds.CirclePrimitive, ptb.bounds.XYBounds
      
      if ( ~ptb.Window.is_valid_window(window) )
        return
      end
      
      if ( nargin < 3 || isempty(color) )
        color = [ 255, 255, 255 ];
      end
      
      rect = get_rect( obj );
      
      try
        Screen( 'FrameOval', window.WindowHandle, color, rect );
      catch err
        warning( err.message );
      end
    end
  end
  
  methods (Access = protected, Abstract = true)
    get_center(obj);
    get_radius(obj);
  end
  
  methods (Access = protected)
    function rect = get_rect(obj)
      center = get_center( obj );
      radius = get_radius( obj );
      
      x1 = center(1) - radius;
      x2 = center(1) + radius;
      y1 = center(2) - radius;
      y2 = center(2) + radius;
      
      rect = [ x1, y1, x2, y2 ];
    end
  end
  
end