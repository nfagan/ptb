% See also ptb.WindowDependent/WindowDependent
% % @T import ptb.Window
% @T import ptb.types
classdef WindowDependent
  
  properties (Access = public)
    %   VALUE -- Raw underlying vector value.
    %
    %     Value is an 1xN vector of raw components. N is given by the
    %     NDimensions property.
    %
    %     See also ptb.WindowDependent, ptb.WindowDependent.Units,
    %       ptb.WindowDependent.NDimensions
    %
    %     @T :: double
    Value;
    
    %   UNITS -- Units of the WindowDependent object's Value.
    %
    %     Units is a char vector indicating the kind of units to use to
    %     scale the raw Value property. Units can be 'px', 'length',
    %     'normalized', or 'degrees'. These are:
    %
    %       - 'px': Pixels. The components of Value are taken to be in
    %         pixels, and will be unscaled.
    %
    %       - 'normalized': Normalized. The components of Value are taken
    %         to be fractional with respect to the width and height of the
    %         window, in pixels. E.g., a Value of [0.5, 0.5] corresponds to
    %         half the pixel-width and half the pixel-height of the window.
    %
    %       - 'length': The components of Value are expressed in the same
    %         physical units, such as cm, as the PhysicalDimensions of the 
    %         window.
    %
    %       - 'degrees': Degrees of visual angle. The components of Value
    %         are expressed in degrees of visual angle, and must be
    %         interpreted with respect to a) the physical height of the 
    %         window and b) the viewing distance between the subject and
    %         the monitor.
    %
    %     See also ptb.WindowDependent, ptb.WindowDependent.as_px,
    %       ptb.Window.PhysicalDimensions, ptb.Window.ViewDistance
    %
    %     @T :: char
    Units = 'px';
  end
  
  properties (GetAccess = public, Constant = true)
    UnitKinds = { 'length', 'px', 'normalized', 'degrees' };
  end
  
  properties (GetAccess = public, SetAccess = private)
    %   NDIMENSIONS -- Number of dimensions of the WindowDependent.
    %
    %     NDimensions is a read-only double scalar giving the number of
    %     dimensions, and thus the number of components, of Value.
    %
    %     See also ptb.WindowDependent, ptb.WindowDependent.Value
    %
    %     @T :: double
    NDimensions = 2;
    
    %   ISNONNEGATIVE -- True if components must be non-negative.
    %
    %     IsNonNegative is a read-only logical scalar indicating whether
    %     the components of the WindowDependent must be non-negative. If 
    %     true, attempting to set a component to a negative value will 
    %     produce an error.
    %
    %     See also ptb.WindowDependent, ptb.WindowDependent.Configured
    %
    %     @T :: logical
    IsNonNegative = false;
  end
  
  methods
    function obj = WindowDependent(value, units, n_dimensions)
      
      %   WindowDependent -- Create WindowDependent object.
      %
      %     A ptb.WindowDependent object represents a vector quantity whose
      %     value must be interpreted with respect to an onscreen window,
      %     according to its units. For example, the object might contain 
      %     fractional values that are intended to be normalized to the 
      %     pixel dimensions of the window.
      %
      %     obj = ptb.WindowDependent(); creates a two-component vector
      %     quantity with units 'px'.
      %
      %     obj = ptb.WindowDependent( value ); sets `obj` to contain
      %     `value`, a two-component vector.
      %
      %     obj = ptb.WindowDependent( value, units ); indicates that 
      %     `value` is expressed in `units`.
      %
      %     obj = ptb.WindowDependent( value, units, num_dimensions );
      %     sets the number of components allowed in `value`.
      %
      %     See also ptb.WindowDependent.Value, ptb.WindowDependent.Units,
      %       ptb.WindowDependent.as_px, ptb.WindowDependent.set
      
      if ( nargin == 3 )
        obj.NDimensions = n_dimensions;
      end
      
      obj.Value = zeros( 1, obj.NDimensions );
      
      if ( nargin > 0 )
        obj = set( obj, value );
      end
      
      if ( nargin > 1 )
        obj.Units = units;
      end
    end
    
    % @T :: [ptb.WindowDependent] = (ptb.WindowDependent, char)
    function obj = set.Units(obj, units)
      obj.Units = validatestring( units, obj.UnitKinds, mfilename, 'Units' );
    end
    
    % @T :: [ptb.WindowDependent] = (ptb.WindowDependent, double)
    function obj = set.Value(obj, value)
      obj.Value = check_value( obj, value );
    end
    
    % @T :: [ptb.WindowDependent] = (ptb.WindowDependent, double)
    function obj = set.NDimensions(obj, value)
      validateattributes( value, {'numeric'}, {'scalar', 'positive'} ...
        , mfilename, 'NDimensions' );      
      obj.NDimensions = double( value );
    end
  end
  
  methods (Access = public)    
    % @T :: [ptb.WindowDependent] = (ptb.WindowDependent, double | ptb.WindowDependent)
    function obj = set(obj, B)
      
      %   SET -- Set contents.
      %
      %     A = set( A, B ), where `A` and `B` are both ptb.WindowDependent
      %     objects, sets the Units and Value of `A` to those of `B`.
      %
      %     A = set( obj, value ) where `obj` is a ptb.WindowDependent 
      %     object, and `value` is a numeric array, sets the Value of `A` 
      %     to `value`.
      %
      %     See also ptb.WindowDependent, ptb.WindowDependent.as_px
      
      try
        if ( isa(B, 'ptb.WindowDependent') )
          obj.Value = B.Value;
          obj.Units = B.Units;
        else
          % @T cast double
          obj.Value = B;
        end
      catch err
        throw( err );
      end
    end
    
    function value = get(obj)
      
      %   GET -- Get raw value.
      %
      %     v = get( obj ); is the same as v = obj.Value;
      %
      %     See also ptb.WindowDependent
      
      value = obj.Value;
    end
    
    % @T :: [ptb.WindowDependent] = (ptb.WindowDependent, ptb.MaybeWindow)
    function obj = in_px(obj, varargin)
      
      %   IN_PX -- Object with value in pixels.
      %
      %     out = in_px( obj, window ); converts Value to pixels, and
      %     returns a new object `out` containing this value.
      %
      %     See also ptb.WindowDependent, ptb.WindowDependent.as_px
      
      obj.Value = as_px( obj, varargin{:} );
      obj.Units = 'px';
    end
    
    % @T :: [ptb.WindowDependent] = (ptb.WindowDependent, ptb.MaybeWindow)
    function obj = in_normalized(obj, varargin)
      
      %   IN_NORMALIZED -- Object with value in normalized units.
      %
      %     out = in_normalized( obj, window ); converts Value such that
      %     it is fractional with respect to the pixel dimensions of
      %     `window`, and returns a new object `out` containing this value.
      %
      %     See also ptb.WindowDependent, ptb.WindowDependent.as_normalized
      
      obj.Value = as_normalized( obj, varargin{:} );
      obj.Units = 'normalized';
    end
    
    % @T :: [double] = (ptb.WindowDependent, ptb.MaybeWindow)
    function out = as_px(obj, win)
      
      %   AS_PX -- Get value in pixels.
      %
      %     p = as_px( obj, window ); returns the value of the
      %     object in pixels, as referenced to the ptb.Window object 
      %     `window`.
      %
      %     If Units is 'px', then p is the same as obj.Value.
      %
      %     If Units is 'normalized', then p is the value of obj.Value
      %     multiplied by the pixel width and height of `window`. If 
      %     `window` is Null, then the components of `p` are NaN. If `obj`
      %     is one-dimensional, the component is multiplied by the width of
      %     `window`. If `obj` has more than two dimensions, the
      %     remaining dimensions are multiplied by the width of `window`.
      %
      %     If Units is 'length', then p is the pixel value of obj.Value, 
      %     using the physical dimensions of `window` for reference. If 
      %     `window` is Null, or the physical dimensions of `window` are 
      %     unset, then the components of `p` are NaN. If `obj` is 
      %     one-dimensional, the component is scaled by the physical width 
      %     of `window`. If `obj` has more than two dimensions, the 
      %     remaining dimensions are scaled by the physical width of 
      %     `window`.
      %
      %     See also ptb.WindowDependent, ptb.WindowDependent.Value,
      %       ptb.WindowDependent.Units
      
      value = obj.Value;
      
      if ( strcmp(obj.Units, 'px') )
        % Pixels do not depend on the window.
        out = value;
        return
      end
      
      if ( isempty(win) || ptb.isnull(win) )
        % Other units depend on the dimensions of the Window, so if the
        % window is unspecified, return early.
        out = nan( 1, obj.NDimensions );
        return
      end
      
      % @T cast ptb.Window
      window = win;
      w = window.Width;
      h = window.Height;
      
      switch ( obj.Units )
        case 'normalized'
          out = value;
          
          out(1) = w * value(1);
          
          if ( obj.NDimensions > 1 )
            out(2) = h * value(2);
          end
          
          if ( obj.NDimensions > 2 )
            % Normalize remaining dimensions to width.
            out(3:end) = w * out(3:end);
          end
          
        case 'degrees'
          view_distance = window.ViewDistance;
          physical_height = window.PhysicalDimensions(2);
          deg_per_px = rad2deg( atan2(0.5 * physical_height, view_distance) ) / (0.5 * h);
          px_per_deg = 1 / deg_per_px;
          out = value * px_per_deg;
          
        case 'length'
          physical_dimensions = window.PhysicalDimensions;
          ratio_px_cm_w = w / physical_dimensions(1);
          ratio_px_cm_h = h / physical_dimensions(2);
          
          out = value;
          out(1) = out(1) * ratio_px_cm_w;
          
          if ( obj.NDimensions > 1 )
            out(2) = out(2) * ratio_px_cm_h;
          end
          
          if ( obj.NDimensions > 2 )
            out(3:end) = out(3:end) * ratio_px_cm_w;
          end
        otherwise
          error( 'Unrecognized units "%s".', obj.Units );
      end
    end
    
    % @T :: [double] = (ptb.WindowDependent, ptb.MaybeWindow)
    function out = as_normalized(obj, win)
      
      %   AS_NORMALIZED -- Get value in normalized units.
      %
      %     p = as_normalized( obj, window ); returns the value of 
      %     the object as normalized to the pixel width and height of
      %     `window`.
      %
      %     If Units is 'normalized', then p is the same as obj.Value.
      %
      %     If Units is 'px', then p is obj.Value normalized to the pixel 
      %     width and height of `window`. If `window` is Null, then the 
      %     components of `p` are NaN. If `obj` is one-dimensional, the 
      %     component is normalized to the width of `window`. If `obj` has 
      %     more than two dimensions, the remaining dimensions are 
      %     normalized to the width of `window`.
      %
      %     If Units is 'length', then p is the normalized value of obj.Value, 
      %     using the physical dimensions of `window` for reference. If 
      %     `window` is Null, or the physical width of `window` is unset,
      %     then the components of `p` are NaN.
      %
      %     See also ptb.WindowDependent, ptb.WindowDependent.Value,
      %       ptb.WindowDependent.Units
      
      value = obj.Value;
      
      if ( strcmp(obj.Units, 'normalized') )
        % Already normalized.
        out = value;
        return
      end
      
      if ( isempty(win) || ptb.isnull(win) )
        out = nan( 1, obj.NDimensions );
        return
      end
      
      % @T cast ptb.Window
      window = win;
      w = window.Width;
      h = window.Height;
      
      switch ( obj.Units )
        case 'px'
          out = get_normalized_value_from_px( obj, value, w, h );
          
        case {'length', 'degrees'}
          out = get_normalized_value_from_px( obj, as_px(obj, window), w, h );
          
        otherwise
          error( 'Unrecognized units "%s".', obj.Units );
      end      
    end
  end
  
  methods (Access = private)
    % @T :: [double] = (ptb.WindowDependent, double, double, double)
    function p = get_normalized_value_from_px(obj, value, w, h)
      
      p = value;

      p(1) = p(1) / w;

      if ( obj.NDimensions > 1 )
        p(2) = p(2) / h;
      end

      if ( obj.NDimensions > 2 )
        %   Normalize remaining dimensions to width.
        p(3:end) = p(3:end) / w;
      end
    end
    
    % @T :: [double] = (ptb.WindowDependent, double)
    function v = check_value(obj, value)
      N = obj.NDimensions;
      
      if ( numel(value) == 1 )
        value = repmat( value, 1, N );
      end
      
      attrs = { 'numel', N };
      
      if ( obj.IsNonNegative )
        attrs{end+1} = 'nonnegative';
      end
      
      validateattributes( value, {'numeric'}, attrs, mfilename, 'Value' );
      
      v = double( value(:)' );
    end
    
    % @T :: [] = (ptb.WindowDependent, ptb.Window)
    function from_window(obj, window)
    end
  end
  
  methods (Access = public, Static = true)
    function t = Configured(varargin)
      
      %   CONFIGURED -- Create ptb.WindowDependent configured with read-only
      %     property values.
      %
      %     t = ptb.WindowDependent.Configured( 'name1', value1, ... ) 
      %     creates a ptb.WindowDependent object `t` whose property values 
      %     are set in 'name', value pairs. This is the only way to set 
      %     certain properties such as IsNonNegative, which cannot be 
      %     changed after `t` is created.
      %
      %     See also ptb.WindowDependent, ptb.WindowDependent.IsNonNegative
      
      p = inputParser();
      
      logical_scalar_validator = ....
        @(x, kind) validateattributes( x, {'logical'}, {'scalar'}, mfilename, kind );
      
      addParameter( p, 'IsNonNegative', false, @(x) logical_scalar_validator(x, 'IsNonNegative') );
      addParameter( p, 'NDimensions', 2 );
      addParameter( p, 'Units', 'px' );
      addParameter( p, 'Value', [] );
      
      parse( p, varargin{:} );
      
      results = p.Results;
      
      t = ptb.WindowDependent( nan, results.Units, results.NDimensions );
      
      t.IsNonNegative = results.IsNonNegative;
      
      if ( ~isempty(results.Value) )
        t = set( t, results.Value );
      end
    end    
    
    % @T :: [ptb.WindowDependent] = (double, char)
    function t = OneDimensional(value, units)
      
      if ( nargin < 1 )
        value = 0;
      end
      
      if ( nargin < 2 )
        units = 'px';
      end
      
      t = ptb.WindowDependent( value, units, 1 );
    end
  end
end