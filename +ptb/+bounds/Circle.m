classdef Circle < ptb.XYBounds
  
  properties (Access = public)
    Center = ptb.Transform( nan );
    Radius = nan;
  end
  
  methods
    function obj = Circle()
      obj = obj@ptb.XYBounds();
    end
    
    function set.Center(obj, v)
      obj.Center = set( obj.Center, v );
    end
    
    function set.Radius(obj, v)
      
      validateattributes( v, {'numeric'}, {'scalar', 'nonnegative'} ...
        , mfilename, 'Radius' );
      
      obj.Radius = double( v );
    end
  end
  
  methods (Access = public)
    function tf = test(obj, x, y)
      center = get_center( obj );
      radius = get_radius( obj );
      
      x2 = center(1);
      y2 = center(2);
      
      tf = ptb.util.distance( x, y, x2, y2 ) <= radius;
    end
  end
  
  methods (Access = protected)
    function center = get_center(obj)
      center = get( obj.Center );
    end
    
    function radius = get_radius(obj)
      radius = obj.Radius;
    end
  end
  
end