function oval = Oval(varargin)

%   OVAL -- Create Rect stimulus pre-configured as Oval.
%
%     oval = ptb.stimuli.Oval() creates a ptb.stimuli.Rect object whose
%     underlying shape is an oval.
%
%     It is a shorthand for:
%       oval = ptb.stimuli.Rect(); oval.Shape = 'Oval';
%
%     See also ptb.stimuli.Rect

oval = ptb.stimuli.Rect( varargin{:} );
oval.Shape = 'Oval';

end