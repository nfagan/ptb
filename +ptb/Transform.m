classdef Transform
  
  properties (Access = public)
    %   VALUE -- Underlying vector value.
    %
    %     Value is an 1xN vector of raw components, which may be scaled
    %     depending on the value of Units. N is given by the NDimensions
    %     property.
    %
    %     See also ptb.Transform, ptb.Transform.Units,
    %       ptb.Transform.NDimensions
    Value;
    
    %   UNITS -- Units of the Transform.
    %
    %     Units is a char vector indicating the kind of units to use to
    %     scale the raw Value property. Units can be 'px', 'cm', or
    %     'normalized'.
    %
    %       - 'px': Pixels. The components of Value are taken to be in
    %         pixels, and will be unscaled.
    %       - 'cm': cm. The components of Value are taken to be in cm, and
    %         will be scaled to the physical dimensions of the window.
    %       - 'normalized': Normalized. The components of Value are taken
    %         to be fractional with respect to the width and height of the
    %         window, in pixels. E.g., a Value of [0.5, 0.5] corresponds to
    %         half the width and half the height of the window.
    %
    %     See also ptb.Transform, ptb.Transform.get_pixel_value.
    Units = 'px';
  end
  
  properties (GetAccess = public, Constant = true)
    UnitKinds = { 'cm', 'px', 'normalized' };
  end
  
  properties (GetAccess = public, SetAccess = private)
    %   NDIMENSIONS -- Number of dimensions of the Transform.
    %
    %     NDimensions is a read-only double scalar giving the number of
    %     dimensions, and thus the number of components, of Value.
    %
    %     See also ptb.Transform, ptb.Transform.Value
    NDimensions = 2;
  end
  
  methods
    function obj = Transform(value, units)
      
      %   TRANSFORM -- Create Transform object.
      %
      %     obj = ptb.Transform() creates a Transform object -- an object
      %     that represents a physical aspect of a visual stimulus, such as
      %     its position or size, with selectable units.
      %
      %     See also ptb.Transform.Value, ptb.Transform.Units,
      %       ptb.Transform.get_pixel_value, ptb.Transform.set
      
      obj.Value = zeros( 1, obj.NDimensions );
      
      if ( nargin > 0 )
        obj = set( obj, value );
      end
      
      if ( nargin > 1 )
        obj.Units = units;
      end
    end
    
    function obj = set.Units(obj, units)
      obj.Units = validatestring( units, obj.UnitKinds, mfilename, 'Units' );
    end
    
    function obj = set.Value(obj, value)
      obj.Value = check_value( obj, value );
    end
  end
  
  methods (Access = public)    
    function obj = set(obj, B)
      
      %   SET -- Set contents.
      %
      %     A = set( A, B ), where `A` and `B` are both ptb.Transform
      %     objects, sets the Units and Value of `A` to those of `B`.
      %
      %     A = set( obj, value ) where `obj` is a ptb.Transform object, and
      %     `value` is a numeric array, sets the Value of `A` to `value`.
      %
      %     See also ptb.Transform, ptb.Transform.get_pixel_value
      
      if ( isa(B, 'ptb.Transform') )
        obj.Value = B.Value;
        obj.Units = B.Units;
      else
        obj.Value = B;
      end
    end
    
    function value = get(obj)
      
      %   GET -- Get raw value.
      %
      %     v = get( obj ); is the same as v = obj.Value;
      %
      %     See also ptb.Transform
      
      value = obj.Value;
    end
    
    function out = get_pixel_value(obj, window)
      
      %   GET_PIXEL_VALUE -- Get value in pixels, accounting for Units.
      %
      %     p = get_pixel_value( obj, window ); returns the value of the
      %     object in pixels, taking into account the Units of `obj`, using
      %     the ptb.Window object `window`.
      %
      %     If Units is 'px', then p is the same as obj.Value.
      %
      %     If Units is 'normalized', then p is the value of obj.Value
      %     normalized to the width and height of `window`. If `window`
      %     is empty, then the components of `p` are NaN.
      %
      %     If Units is 'cm', then p is the pixel value of obj.Value, using
      %     the physical dimensions of `window` for reference. If `window`
      %     is empty, or the physical dimensions of `window` are unset, 
      %     then the components of `p` are NaN.
      %
      %     See also ptb.Transform, ptb.Transform.Value,
      %       ptb.Transform.Units
      
      value = obj.Value;
      
      if ( strcmp(obj.Units, 'px') )
        % Pixels do not depend on the window.
        out = value;
        return
      end
      
      if ( isempty(window) )
        % Other units depend on the dimensions of the Window, so if the
        % window is unspecified, return early.
        out = nan( 1, obj.NDimensions );
        return
      else
        validateattributes( window, {'ptb.Window'}, {'scalar'} ...
          , mfilename, 'window' );
      end
      
      w = window.Width;
      h = window.Height;
      
      switch ( obj.Units )
        case 'cm'
          physical_dimensions = window.PhysicalDimensions;
          ratio_px_cm = w ./ physical_dimensions(1);
          
          out = value * ratio_px_cm;
          
        case 'normalized'
          out = value;
          
          out(1) = w * value(1);
          out(2) = h * value(2);
          
          if ( obj.NDimensions > 2 )
            % Normalization doesn't make sense in the 3-rd dimension.
            out(3) = value(3);
          end
        otherwise
          error( 'Unrecognized units "%s".', obj.Units );
      end
    end
  end
  
  methods (Access = private)
    function v = check_value(obj, value)
      N = obj.NDimensions;
      
      if ( numel(value) == 1 )
        value = repmat( value, 1, N );
      end
      
      validateattributes( value, {'numeric'}, {'numel', N}, mfilename, 'Value' );
      
      v = double( value(:)' );
    end
  end
end