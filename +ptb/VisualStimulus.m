classdef VisualStimulus < handle
  
  properties (Access = public)
    %   WINDOW -- Window in which to draw stimulus.
    %
    %     Window is either a handle to the ptb.Window object in which to
    %     draw the stimulus, or the empty matrix ([]).
    %
    %     If Window is empty, or if the ptb.Window is not open, drawing the
    %     stimulus will have no effect.
    %
    %     See also ptb.VisualStimulus, ptb.VisualStimulus.Position
    Window = [];
    
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
      
      if ( nargin < 1 )
        win = [];
      end
      
      obj.Position = ptb.Transform();
      obj.Scale = ptb.Transform();
      obj.Window = win;
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
      else
        obj.FaceColor = check_color( obj, color, obj.FaceColor );
      end
    end
    
    function set.EdgeColor(obj, color)
      obj.EdgeColor = check_color( obj, color, obj.EdgeColor );
    end
    
    function set.Window(obj, w)
      if ( isempty(w) )
        w = [];
      else
        validateattributes( w, {'ptb.Window'}, {'scalar'}, mfilename, 'Window' );
      end
      
      obj.Window = w;
    end
  end
  
  methods (Abstract = true)
    draw(obj);
  end
  
  methods (Access = protected)
    function [win, is_valid] = get_window(obj)
      win = obj.Window;
      is_valid = ~isempty( win ) && win.IsOpen && ~isnan( win.WindowHandle );
    end
    
    function color = check_color(obj, color, prop)
      if ( ~isa(color, 'ptb.Color') && ~isa(color, 'ptb.Null') )
        color = set( prop, color );
      end
    end
  end
  
end