classdef PolygonPrimitive < ptb.XYBounds
  
  methods
    function obj = PolygonPrimitive()
      
      %   POLYGONPRIMITIVE -- Abstract interface for polygon bounds.
      %
      %     ptb.PolygonPrimitive describes an interface for testing whether
      %     an (X, Y) coordinate is in bounds of a polygon of arbitrary
      %     shape.
      %
      %     This class is not meant to be used directly; instead, you must
      %     create your own subclass of ptb.PolygonPrimitive that
      %     implements the get_vertices() method.
      %
      %     See also ptb.bounds.PolygonPrimitive.get_vertices
      
    end
  end
  
  methods (Abstract = true)
    
    %   GET_VERTICES -- Obtain (x, y) vertices.
    %
    %     vertices = get_vertices(obj) returns an Mx2 matrix of M (X, Y)
    %     vertices. Each row is a vertex. If you are subclassing this
    %     ptb.PolygonPrimitive class, you must (and need only) implement
    %     this method.
    %
    %     See also ptb.PolygonPrimitive, ptb.PolygonPrimitive.draw
    get_vertices(obj);
  end
  
  methods (Access = public)
    function tf = test(obj, x, y)
      
      %   TEST -- True if (x, y) position is in bounds.
      %
      %     This function makes use of the built-in Matlab function
      %     `inpolygon` to determine whether a point is in bounds.
      %
      %     See also ptb.bounds.PolygonPrimitive.get_vertices,
      %       ptb.XYBounds, inpolygon
      
      vertices = get_vertices( obj );
      
      if ( isempty(vertices) )
        tf = false;
      else
        tf = inpolygon( x, y, vertices(:, 1), vertices(:, 2) );
      end
    end
    
    function draw(obj, window, color)
      
      %   DRAW -- Draw outline of polygon bounds.
      %
      %     draw( obj, window ); draws an outline of the bounding polygon 
      %     in `obj` into `window`, a ptb.Window object.
      %
      %     draw( obj, window, color ); uses `color` to style the outline.
      %     `color` is a 3- or 4-element vector.
      %
      %     See also ptb.bounds.PolygonPrimitive, ptb.bounds.XYBounds
      
      if ( ~ptb.Window.is_valid_window(window) )
        return
      end
      
      if ( nargin < 3 || isempty(color) )
        color = [ 255, 255, 255 ];
      end
      
      vertices = get_vertices( obj );
      
      try
        Screen( 'FramePoly', window.WindowHandle, color, vertices );
      catch err
        warning( err.message );
      end
    end
  end
end