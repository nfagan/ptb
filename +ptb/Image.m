classdef Image
  
  properties (SetAccess = private, GetAccess = public)
    
    %   TEXTUREHANDLE -- Handle to underyling Psychtoolbox texture.
    %
    %     TextureHandle is a read-only double scalar giving the handle to
    %     the underlying Psychtoolbox texture in the object. If the object
    %     is default-constructed, this value is NaN, indicating that no
    %     valid texture handle is present.
    %
    %     See also ptb.Image
    
    TextureHandle = nan;
  end
  
  methods
    function obj = Image(window_handle, image_matrix)
      
      %   IMAGE -- Create static image texture.
      %
      %     obj = ptb.Image() creates an image object with its
      %     TextureHandle set to NaN.
      %
      %     obj = ptb.Image( window, matrix ) creates an image object
      %     associated with `window`, with data from `matrix`. See the
      %     `create` method for more information.
      %
      %     See also ptb.Image.Create, ptb.Image.TextureHandle
      
      if ( nargin > 0 )
        try
          obj = create( obj, window_handle, image_matrix );
        catch err
          throw( err );
        end
      end
    end
  end
  
  methods (Access = public)
    function obj = create(obj, window, mat)
      
      %   CREATE -- Create texture from image matrix.
      %
      %     obj = create( obj, window, image_matrix ) creates an image
      %     texture associated with `window`, with data from 
      %     `image_matrix`.
      %
      %     If `window` is a double scalar, it is the handle to a
      %     valid, open Psychtoolbox window.
      %
      %     If `window` is instead a ptb.Window object, it must be open,
      %     and associated with a valid underlying Psychtoolbox window.
      %
      %     See also ptb.Image, ptb.Image.TextureHandle, ptb.Window,
      %       Screen
      
      if ( isa(window, 'ptb.Window') )
        if ( ~is_window_handle_valid(window) )
          error( 'The underlying Psychtoolbox window is not open, or is invalid.' );
        end
        
        window = window.WindowHandle;
      else
        validateattributes( window, {'double'}, {'scalar', 'nonnan'} ...
          , mfilename, 'window handle' );
      end
      
      obj.TextureHandle = Screen( 'MakeTexture', window, mat );
    end
  end
  
end