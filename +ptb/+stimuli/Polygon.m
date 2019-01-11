classdef Polygon < ptb.VisualStimulus
  
  properties (Access = public)
    %   VERTICES -- Raw, unscaled (x, y) vertices.
    %
    %     Vertices is an Mx2 matrix of M (x, y) vertices defining the polygon.
    %     The actual drawn vertices may be transformed depending on the
    %     value of TransformVertices, but the value of Vertices always 
    %     remains raw and unscaled.
    %
    %     See also ptb.stimuli.Polygon,
    %     ptb.stimuli.Polygon.TransformVertices
    Vertices = [];
    
    %   TRANSFORMVERTICES -- True if vertices should be transformed.
    %
    %     TransformVertices is a logical scalar indicating whether to
    %     translate the object's vertices such that the centroid of the
    %     polygon is located at Position, and whether to scale the
    %     vertices such that the (x, y) radii of the smallest ellipse 
    %     enclosing all vertices, centered at the centroid, is given by 
    %     Scale. Default is true. If false, the object's Vertices are taken
    %     to be in pixels, and are used to draw the polygon unmodified.
    %
    %     See also ptb.stimuli.Polygon,
    %     ptb.stimuli.Polygon.get_pixel_vertices,
    %     ptb.VisualStimulus.Position, ptb.VisualStimulus.Scale
    TransformVertices = true;
  end
  
  methods
    function obj = Polygon(varargin)
      
      %   POLYGON -- Create a 2-D Polygon visual stimulus.
      %
      %     obj = ptb.stimuli.Polygon() creates an object representing a
      %     2-D filled polygon, with user-settable vertices. Vertices can
      %     be manually specified, or optionally tranformed such that their
      %     centroid is at a given position, and such that they are scaled
      %     to a certain (x, y) size.
      %
      %     See also ptb.stimuli.Polygon.get_pixel_vertices,
      %     ptb.stimuli.Polygon.Vertices,
      %     ptb.stimuli.Polygon.TransformVertices, ptb.VisualStimulus
      
      obj = obj@ptb.VisualStimulus( varargin{:} );
    end
    
    function set.Vertices(obj, v)
      if ( isempty(v) )
        obj.Vertices = [];
        return
      elseif ( ~isnumeric(v) || ~ismatrix(v) || size(v, 2) ~= 2 )
        error( 'Vertices must be an Mx2 numeric array.' );
      end
      
      obj.Vertices = double( v );
    end
    
    function set.TransformVertices(obj, v)
      validateattributes( v, {'numeric', 'logical'}, {'scalar'} ...
        , mfilename, 'TransformVertices' );
      obj.IsCentroidOrigin = logical( v );
    end
  end
  
  methods (Access = public)
    
    function draw(obj, window)
      if ( nargin < 2 )
        window = obj.Window;
      end
      
      if ( ~ptb.Window.is_valid_window(window) )
        return
      end
      
      verts = get_pixel_vertices( obj, window );
      
      if ( isempty(verts) )
        return
      end
      
      window_handle = window.WindowHandle;
      
      face_color = obj.FaceColor;
      edge_color = obj.EdgeColor;
      
      % If facecolor is null or an Image, don't draw.
      if ( isa(face_color, 'ptb.Color') )
        Screen( 'FillPoly', window_handle, get(face_color), verts );
      end
      
      % If edgecolor is null or an Image, don't draw.
      if ( isa(edge_color, 'ptb.Color') )
        Screen( 'FramePoly', window_handle, get(edge_color), verts );
      end
    end
    
    function [verts, centroid] = get_pixel_vertices(obj, window)
      
      %   GET_PIXEL_VERTICES -- Get vertices in pixel units.
      %
      %     verts = get_pixel_vertices( obj ); returns the vertices of the
      %     polygon in pixels. `verts` is an Mx2 matrix of M (x, y) vertices.
      %
      %     If TransformVertices is false, then `verts` is equivalent to
      %     Vertices. Otherwise, `verts` is the result of transforming
      %     Vertices such that their centroid is at Position, and such that
      %     the (x, y) radii of the smallest ellipse enclosing all vertices,
      %     centered at the centroid, is given by Scale. The Window in
      %     `obj` is used to interpret units of Position and Scale.
      %
      %     [..., centroid] = get_pixel_vertics( obj ) also returns the
      %     (x, y) centroid of the polygon, in pixels.
      %
      %     [...] = get_pixel_vertices( obj, window ) uses `window` to
      %     interpret the units of Position and Scale of `obj`, instead of 
      %     the value of its Window property.
      %
      %     See also ptb.stimuli.Polygon, ptb.stimuli.Polygon.Vertices,
      %       ptb.stimuli.Polygon.TransformVertices, ptb.VisualStimulus
      
      if ( nargin < 2 )
        window = obj.Window;
      end
      
      verts = obj.Vertices;
      should_output_centroid = nargout > 1;
      
      if ( isempty(verts) )
        centroid = [];
        return
      elseif ( ~obj.TransformVertices )
        if ( should_output_centroid )
          centroid = ptb.util.polygon_centroid( verts(:, 1), verts(:, 2) );
        end
        return
      end
      
      xv = verts(:, 1);
      yv = verts(:, 2);
      
      centroid = ptb.util.polygon_centroid( xv, yv );
      dists = ptb.util.distance( xv, yv, centroid(1), centroid(2) );
      
      pos = get_pixel_value( obj.Position, window );
      scl = get_pixel_value( obj.Scale, window );
      
      xv = xv - centroid(1);
      yv = yv - centroid(2);
      
      largest_dist = max( dists );
      largest_dist_ratio = scl / largest_dist;
      
      xv = xv * largest_dist_ratio(1);
      yv = yv * largest_dist_ratio(2);
      
      xv = xv + pos(1);
      yv = yv + pos(2);
      
      verts = [ xv, yv ];
      
      if ( should_output_centroid )
        centroid = ptb.util.polygon_centroid( xv, yv );
      end
    end
  end
end