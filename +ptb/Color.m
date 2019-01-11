classdef Color
  
  properties (Access = public)
    R = 0;
    G = 0;
    B = 0;
    A = 255;
  end
  
  properties (GetAccess = public, SetAccess = private)
    %   MAXIMUM -- Maximum value of a component.
    %
    %     Maximum is a read-only double scalar giving the maximum value
    %     that a component can take. Default is 255.
    %
    %     See also ptb.Color, ptb.Color.IsInteger
    Maximum = 255;
    
    %   ISINTEGER -- True if components must be integer-valued.
    %
    %     IsInteger is a read-only logical scalar indicating whether R, G,
    %     B, and A components must be integer-valued. Default is true.
    %
    %     See also ptb.Color, ptb.Color.Maximum
    IsInteger = true;
  end
  
  methods
    function obj = Color(varargin)
      
      %   COLOR -- Create Color object.
      %
      %     obj = ptb.Color() creates an object representing an RGBA color.
      %     `obj` has R, G, B, and A properties, which must be 
      %     integer-valued scalars in the range [0, 255].
      %
      %     obj = ptb.Color( 'Maximum', maximum ); indicates that the
      %     maximum value of a component of `obj` should be `maximum`.
      %
      %     obj = ptb.Color( ..., 'IsInteger', is_integer ); controls
      %     whether the components of `obj` must be integer-valued.
      %
      %     See also ptb.Color.Maximum, ptb.Color.set
      
      if ( nargin == 0 )
        return
      end
      
      obj = parse_obj( obj, varargin );
    end
    
    function obj = set.R(obj, v)
      obj.R = validate_component( obj, v, 'R' );
    end
    
    function obj = set.G(obj, v)
      obj.G = validate_component( obj, v, 'G' );
    end
    
    function obj = set.B(obj, v)
      obj.B = validate_component( obj, v, 'B' );
    end
    
    function obj = set.A(obj, v)
      obj.A = validate_component( obj, v, 'A' );
    end
  end
  
  methods (Access = public)
    function color = get(obj)
      
      %   GET -- Get components in vector form.
      %
      %     color = get( obj ); returns a 1x4 vector containing the 
      %     [ R, G, B, A ] components of `obj`.
      %
      %     See also ptb.Color, ptb.Color.set
      
      color = [ obj.R, obj.G, obj.B, obj.A ];
    end
    
    function obj = set(obj, color)
      
      %   SET -- Set components.
      %
      %     obj = set( obj, components ); assigns the [r, g, b, a]
      %     components of vector `components` to the corresponding
      %     properties of `obj`.
      %
      %     obj = set( obj, B ); where `B` is another ptb.Color object,
      %     attempts to assign the contents of `B` to `obj`. An error is
      %     thrown if the contents of `B` 
      %
      %     See also ptb.Color, ptb.Color.get
      
      if ( isa(color, 'ptb.Color') )
        obj.R = color.R;
        obj.B = color.B;
        obj.G = color.G;
        obj.A = color.A;
        return
      end
      
      if ( numel(color) == 3 )
        a = obj.Maximum;
      else
        validateattributes( color, {'numeric'}, {'numel', 4}, mfilename, 'color' );
        a = color(4);
      end
      
      obj.R = color(1);
      obj.G = color(2);
      obj.B = color(3);
      obj.A = a;
    end
  end
  
  methods (Access = private)
    function obj = parse_obj(obj, inputs)
      
      p = inputParser();
      
      addParameter( p, 'IsInteger', obj.IsInteger ...
        , @(v) validateattributes(v, {'logical'}, {'scalar'}, mfilename, 'IsInteger') );
      addParameter( p, 'Maximum', obj.Maximum ...
        , @(v) validateattributes(v, {'numeric'}, {'scalar', 'nonnan'}, mfilename, 'Maximum') );
      
      parse( p, inputs{:} );
      
      results = p.Results;
      
      obj.Maximum = results.Maximum;
      obj.IsInteger = results.IsInteger;
      obj.A = results.Maximum;
    end
    
    function component = validate_component(obj, component, kind)
      
      classes = { 'numeric' };
      attrs = { 'scalar', 'nonnegative', 'nonnan', '<=', obj.Maximum };
      
      if ( obj.IsInteger )
        attrs{end+1} = 'integer';
      end
      
      validateattributes( component, classes, attrs, mfilename, kind );
      
      component = double( component );      
    end
  end
  
  methods (Access = public, Static = true)
    function c = ZeroOne()
      c = ptb.Color( 'Maximum', 1, 'IsInteger', false );
    end
    
    function c = White()
      c = set( ptb.Color(), [255, 255, 255] );
    end
    
    function c = Red()
      c = set( ptb.Color(), [255, 0, 0] );
    end
    
    function c = Green()
      c = set( ptb.Color(), [0, 255, 0] );
    end
    
    function c = Blue()
      c = set( ptb.Color(), [0, 0, 255] );
    end
  end
  
end