classdef Circle < ptb.bounds.CirclePrimitive
  
  properties (Access = public)
    %   WINDOW -- Window with which to interpret units of Center and Radius.
    %
    %     Window is a ptb.Window object giving the window to which non-px
    %     units of Center and Radius will be referenced. For example, if
    %     the units of Radius are 'normalized', then the value of Radius
    %     will be normalized to the pixel width of the window.
    %
    %     Window can also be a ptb.Null object, representing the absence of
    %     a window. In this case, if the units of Center or Radius are not
    %     'px', then their values are NaN.
    Window = ptb.Null;
    
    %   CENTER -- (X, Y) center of the bounding circle.
    %
    %     Center is a ptb.Transform object representing the (X, Y) center
    %     of the circle. The default units are 'px'.
    %
    %     If the units are not 'px' -- i.e., if the value of Center depends
    %     on properties of an on-screen window -- you must set the
    %     Window property, or else the components of Center will be NaN.
    %
    %     See also ptb.bounds.Circle, ptb.bounds.Circle.Window, 
    %       ptb.Transform, ptb.bounds.Circle.Radius
    Center = ptb.Transform( nan );
    
    %   RADIUS -- Radius of the bounding circle.
    %
    %     Radius is a ptb.Transform object representing the radius
    %     of the circle. The default units are 'px'.
    %
    %     If the units are not 'px' -- i.e., if the value of Radius depends
    %     on properties of an on-screen window -- you must set the
    %     Window property, or else the value of Radius will be NaN.
    %
    %     See also ptb.bounds.Circle, ptb.bounds.Circle.Window, 
    %       ptb.Transform
    Radius = ptb.Transform.Configured( 'NDimensions', 1, 'IsNonNegative', true );
  end
  
  methods
    function obj = Circle()
      
      %   CIRCLE -- Create bounds that are a circle.
      %
      %     obj = ptb.bounds.Circle() creates an object that tests whether
      %     an (X, Y) coordinate is in bounds of a circle centered at a
      %     given Center, of a given Radius.
      %
      %     By default, the components of Center and Radius are NaN,
      %     meaning the object's `test` method will always return false.
      %
      %     See also ptb.bounds.Circle.Center, ptb.bounds.Circle.Radius,
      %     ptb.bounds.Circle.Window, ptb.XYBounds
      
      obj = obj@ptb.bounds.CirclePrimitive();
    end
    
    function set.Center(obj, v)
      obj.Center = set( obj.Center, v );
    end
    
    function set.Radius(obj, v)
      obj.Radius = set( obj.Radius, v );
    end
    
    function set.Window(obj, v)
      validateattributes( v, {'ptb.Window', 'ptb.Null'} ...
        , {'scalar'}, mfilename, 'Window' );
      obj.Window = v;
    end
  end
  
  methods (Access = protected)
    function center = get_center(obj)
      center = get_pixel_value( obj.Center, obj.Window );
    end
    
    function radius = get_radius(obj)
      radius = get_pixel_value( obj.Radius, obj.Window );
    end
  end
end