function ptb_check_moveable_polygon()

import ptb.keys.*;

cleanup = onCleanup( @() ListenChar(0) );

w = ptb.Window( [0, 0, 400, 400] );

p = ptb.stimuli.Polygon( w );

p.Position = 0.5;
p.Position.Units = 'normalized';
p.Scale = 100;
p.FaceColor = ptb.Color.Red();

% Square vertices
p.Vertices = [ [0, 1, 1, 0]', [1, 1, 0, 0]' ];

open( w );
ListenChar( 2 );

mv = 0.01;

while ( ~ptb.util.is_esc_down )
  xs = 0; % x-shift
  ys = 0; % y-shift
  
  state = ptb.util.are_keys_down( left, right, up, down, KbName('c') );
  
  if ( state(1) ), xs = xs - mv; end
  if ( state(2) ), xs = xs + mv; end
  if ( state(3) ), ys = ys - mv; end %  invert y
  if ( state(4) ), ys = ys + mv; end %  invert y
  
  if ( state(5) )
    p.Position = 0.5;
  elseif ( xs ~= 0 || ys ~= 0 )
    move( p, xs, ys );
  end
  
  draw( p );
  flip( w );
end

end