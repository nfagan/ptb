classdef VisualStimulus < handle
  
  properties (Access = public)
    %   WINDOW -- Default Window in which to draw stimulus.
    %
    %     Window is a handle to a ptb.Window object giving the window in
    %     which to draw the stimulus. Window can also be a ptb.Null object,
    %     indicating the absence of a window.
    Window = ptb.Null;
    
    %   POSITION -- (X, Y) position of the stimulus.
    %
    %     Position is an object of type ptb.Transform that represents the
    %     (X, Y) position of the stimulus. Unless a subclass of
    %     ptb.VisualStimulus implements it differently, Position gives the
    %     centroid of the stimulus.
    %
    %     See also ptb.VisualStimulus, ptb.Transform, 
    %       ptb.VisualStimulus.Scale, ptb.VisualStimulus.FaceColor
    Position = ptb.Transform();
    
    %   SCALE -- (X, Y) scaling of the stimulus.
    %
    %     Scale is an object of type ptb.Transform that represents the 
    %     (X, Y) scaling of the stimulus. In most cases, this is equivalent
    %     to setting the size of the stimulus.
    %
    %     See also ptb.VisualStimulus, ptb.Transform
    Scale = ptb.Transform();
    
    %   FACECOLOR -- Color of the face of the stimulus.
    %
    %     FaceColor is an object of types ptb.Color, ptb.Image, or ptb.Null
    %     that gives the color of the face of the VisualStimulus.
    %
    %     See also ptb.VisualStimulus, ptb.Color, ptb.Image,
    %       ptb.VisualStimulus.EdgeColor
    FaceColor = ptb.Color();
    
    %   EDGECOLOR -- Color of the edge of the stimulus, if applicable.
    %
    %     EdgeColor is an object of types ptb.Color or ptb.Null that gives
    %     the color of the edge / frame of the VisualStimulus.
    %
    %     See also ptb.VisualStimulus, ptb.Color,
    %       ptb.VisualStimulus.EdgeColor
    EdgeColor = ptb.Null();
  end
  
  methods
    function obj = VisualStimulus(win)
      
      %   VISUALSTIMULUS -- Abstract superclass for visual stimuli.
      %
      %     This class describes an interface for drawing simple, static,
      %     2D visual stimuli.
      %
      %     Objects that implement the ptb.VisualStimulus interface have
      %     Position, Scale, FaceColor, and EdgeColor properties that
      %     define some attributes of their appearence / placement. The
      %     geometry, however, is object specified; in the simplest case,
      %     it is a rectangle.
      %
      %     See also ptb.VisualStimulus.Window,
      %       ptb.VisualStimulus.Position, ptb.stimuli.Rect
      
      if ( nargin == 1 )
        obj.Window = win;
      end
      
      obj.Position = ptb.Transform();
      obj.Scale = ptb.Transform();
    end
    
    function set.Position(obj, v)
      obj.Position = set( obj.Position, v );
    end
    
    function set.Scale(obj, v)
      obj.Scale = set( obj.Scale, v );
    end
    
    function set.FaceColor(obj, color)
      if ( isa(color, 'ptb.Image') )
        obj.FaceColor = color;
      elseif ( isa(obj.FaceColor, 'ptb.Color') )
        obj.FaceColor = check_color( obj, color, obj.FaceColor );
      else
        obj.FaceColor = ptb.Color();
        obj.FaceColor = check_color( obj, color, obj.FaceColor );
      end
    end
    
    function set.EdgeColor(obj, color)
      obj.EdgeColor = check_color( obj, color, obj.EdgeColor );
    end
    
    function set.Window(obj, w)
      validateattributes( w, {'ptb.Window', 'ptb.Null'}, {'scalar'} ...
        , mfilename, 'Window' );
      obj.Window = w;      
    end
  end
  
  methods (Access = public)
    
    function b = clone(obj, constructor)
      
      %   CLONE -- Duplicate object.
      %
      %     See also ptb.VisualStimulus
      
      b = constructor( obj.Window );
      b.Position = obj.Position;
      b.Scale = obj.Scale;
      b.FaceColor = obj.FaceColor;
      b.EdgeColor = obj.EdgeColor;
    end
  end
  
  methods (Abstract = true)
    
    %   DRAW -- Draw stimulus.
    %
    %     draw( obj ); draws `obj` into its Window.
    %
    %     draw( obj, window ); draws `obj` into `window`. `window` is a
    %     valid, open ptb.Window object.
    %
    %     If `window` is not a ptb.Window object, or is invalid, this
    %     function has no effect, and no error is raised.
    %
    %     See also ptb.VisualStimulus
    %
    %     IN:
    %       - `window` (ptb.Window) |OPTIONAL|
    draw(obj, window);
  end
  
  methods (Access = protected)    
    function color = check_color(obj, color, prop)
      if ( ~isa(color, 'ptb.Color') && ~ptb.isnull(color) )
        color = set( prop, color );
      end
    end
  end 
end