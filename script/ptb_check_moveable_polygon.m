function ptb_check_moveable_polygon()

import ptb.keys.*;

cleanup = onCleanup( @() ListenChar(0) );

window = ptb.Window();
open( window );

p = ptb.stimuli.Polygon( window );

updater = ptb.ComponentUpdater();

bounds =  ptb.bounds.MatchPolygon( p );
source =  create_registered( updater, @ptb.sources.Mouse, window );
sampler = create_registered( updater, @ptb.samplers.Pass, source );
targ =    create_registered( updater, @ptb.XYTarget, sampler, bounds );

p.Position = 0.5;
p.Position.Units = 'normalized';
p.Scale = 100;
p.FaceColor = ptb.Color.Red();

% Square vertices
p.Vertices = [ [0, 1, 1, 0]', [1, 1, 0, 0]' ];

ListenChar( 2 );

mv = 0.01;
blue = ptb.Color.Blue;
red = ptb.Color.Red;

while ( ~ptb.util.is_esc_down )
  update( updater );
  
  xs = 0; % x-shift
  ys = 0; % y-shift
  
  state = ptb.util.are_keys_down( left, right, up, down, KbName('c'), space );
  
  if ( state(1) ), xs = xs - mv; end
  if ( state(2) ), xs = xs + mv; end
  if ( state(3) ), ys = ys - mv; end %  invert y
  if ( state(4) ), ys = ys + mv; end %  invert y
  
  if ( state(5) )
    p.Position = 0.5;
  elseif ( xs ~= 0 || ys ~= 0 )
    move( p, xs, ys );
  end
  
  if ( state(6) || targ.IsInBounds )
    p.FaceColor = blue;
  else
    p.FaceColor = red;
  end
  
  draw( p );
  draw( bounds, window );
  flip( window );
end

end