classdef Mouse < ptb.XYSource
  
  properties (Access = private)
    window_handle = 0;
  end
  
  methods
    function obj = Mouse(window_handle)
      
      %   MOUSE -- Create Mouse object instance.
      %
      %     obj = ptb.sources.Mouse() creates an interface for obtaining 
      %     (X, Y) position samples from a mouse. Mouse position is given
      %     with respect to window 0 (i.e., the full desktop).
      %
      %     obj = ptb.sources.Mouse( window_or_screen ) gets the mouse
      %     position with respect to the window or screen given by
      %     `window_or_screen`. An error is thrown if this index is
      %     invalid.
      %
      %     The underlying mouse-position querying depends on the
      %     `GetMouse` function in Psychtoolbox.
      %
      %     See also GetMouse, Screen, ptb.sources.Eyelink,
      %       ptb.sources.Mouse.update
      
      obj = obj@ptb.XYSource();
      
      if ( nargin == 0 )
        window_handle = 0;
      else
        try
          window_handle = ptb.sources.Mouse.validate_window_handle( window_handle );
        catch err
          throw( err );
        end
      end
        
      obj.window_handle = window_handle;
    end
  end
  
  methods (Access = protected)
    function tf = new_sample_available(obj)
      tf = true;
    end
    
    function [x, y, success] = get_latest_sample(obj)
      [x, y] = GetMouse( obj.window_handle );
      success = true;
    end
  end
  
  methods (Access = private, Static = true)
    function window_handle = validate_window_handle(window_handle)
      
      if ( isa(window_handle, 'ptb.Window') )
        if ( ~is_window_handle_valid(window_handle) )
          error( 'The underlying window handle is invalid.' );
        else
          window_handle = window_handle.WindowHandle;
          return
        end
      end
      
      validateattributes( window_handle, {'numeric'}, {'scalar', 'integer'} ...
          , mfilename, 'window_handle' );
      
      window_handle = double( window_handle );
      
      screens = Screen( 'Screens' );
      windows = Screen( 'Windows' );
      
      if ( ~any(screens == window_handle) && ~any(windows == window_handle) )
        error( 'Window or screen index given by %d is invalid.', window_handle );
      end
    end
  end
  
end