classdef Rect < ptb.VisualStimulus
  
  properties (Access = public, Constant = true)
    Shapes = { 'Rectangle', 'Oval' };
  end
  
  properties (Access = public)
    %   SHAPE -- Type of the underlying shape.
    %
    %     Shape is a char vector giving the type of the underlying shape
    %     drawn in a call to `draw`. Options are 'Rectangle' and 'Oval'.
    %
    %     See also ptb.stimuli.Rect
    Shape;
  end
  
  properties (Access = private)
    fill_draw_command;
    frame_draw_command;
  end
  
  methods
    function obj = Rect(varargin)
      
      %   RECT -- Create a 2-D Rect visual stimulus.
      %
      %     obj = ptb.Rect() creates an object representing a 2-D filled
      %     shape inscribed within a rectangle. In the default case, the
      %     underlying shape is a rectangle; in another case, the
      %     underlying shape is an oval inscribed within the rectangle's
      %     bounds.
      %
      %     See also ptb.VisualStimulus, ptb.stimuli.Rect.Shape
      
      obj = obj@ptb.VisualStimulus( varargin{:} );
      
      obj.Shape = 'Rectangle';
    end
    
    function set.Shape(obj, s)
      obj.Shape = validatestring( s, obj.Shapes, mfilename, 'Shape' );
      update_draw_commands( obj );
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
      
      rect = get_rect( obj, window );
      
      face_color = obj.FaceColor;
      edge_color = obj.EdgeColor;
      
      window_handle = window.WindowHandle;
      
      try
        if ( isa(face_color, 'ptb.Color') )
          Screen( obj.fill_draw_command, window_handle, get(face_color), rect );
        elseif ( isa(face_color, 'ptb.Image') )
          Screen( 'DrawTexture', window_handle, face_color.TextureHandle, [], rect );
        end
      catch err
        warning( err.message );
      end
      
      try
        if ( isa(edge_color, 'ptb.Color') )
          Screen( obj.frame_draw_command, window_handle, get(edge_color), rect );
        end
      catch err
        warning( err.message );
      end
    end
    
    function r = get_rect(obj, window)
      if ( nargin < 2 )
        window = obj.Window;
      end
      
      scale = as_px( obj.Scale, window );
      position = as_px( obj.Position, window );
      
      w2 = scale(1) / 2;
      h2 = scale(2) / 2;
      
      x1 = position(1) - w2;
      x2 = position(1) + w2;
      y1 = position(2) - h2;
      y2 = position(2) + h2;
      
      r = [ x1, y1, x2, y2 ];
    end
  end
  
  methods (Access = public)
    
    function b = clone(obj)
      b = clone@ptb.VisualStimulus( obj, @ptb.stimuli.Rect );
      
      b.Shape = obj.Shape;
    end
  end
  
  methods (Access = private)
    function update_draw_commands(obj)
      switch ( obj.Shape )
        case 'Rectangle'
          obj.fill_draw_command = 'FillRect';
          obj.frame_draw_command = 'FrameRect';
        case 'Oval'
          obj.fill_draw_command = 'FillOval';
          obj.frame_draw_command = 'FrameOval';
        otherwise
          error( 'Un-accounted for shape "%s".', obj.Shape );
      end
    end
  end
end