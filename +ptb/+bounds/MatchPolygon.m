classdef MatchPolygon < ptb.bounds.PolygonPrimitive
  
  properties (Access = public)
    
    %   POLYGON -- Underlying Polygon stimulus defining polygon vertices.
    %
    %     Polygon is a handle to a ptb.stimuli.Polygon object from which
    %     vertices will be drawn. It can also be a ptb.Null object,
    %     indicating the absence of an underyling stimulus.
    %
    %     See also ptb.bounds.MatchPolygon
    Polygon = ptb.Null;
  end
  
  methods
    function obj = MatchPolygon(polygon)
      
      %   MATCHPOLYGON -- Create bounds derived from a Polygon stimulus.
      %
      %     obj = ptb.bounds.MatchPolygon( polygon ); creates an object
      %     that tests whether an (x, y) coordinate is in bounds of the
      %     vertices given by the ptb.stimuli.Polygon `polygon`.
      %
      %     obj = ptb.bounds.MatchPolygon() creates a default-constructed
      %     bounds object whose Polygon property is set to ptb.Null, such
      %     that its `test` method always returns false.
      %
      %     See also ptb.bounds.PolygonPrimitive, ptb.stimuli.Polygon,
      %     ptb.bounds.MatchPolygon.Polygon
      
      if ( nargin < 1 )
        polygon = ptb.Null();
      end
      
      obj.Polygon = polygon;
    end
    
    function set.Polygon(obj, p)
      validateattributes( p, {'ptb.Null', 'ptb.stimuli.Polygon'}, {'scalar'} ...
        , mfilename, 'Polygon' );
      obj.Polygon = p;      
    end
    
    function verts = get_vertices(obj)
      if ( ptb.isnull(obj.Polygon) )
        verts = [];
      else
        verts = get_pixel_vertices( obj.Polygon );
      end
    end
  end
end