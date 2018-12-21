function ptb_debug_stimuli()

ptb.util.try_add_ptoolbox();

Screen( 'Preference', 'VisualDebuglevel', 3 );

w = ptb.Window( [0, 0, 200, 200] );
w2 = ptb.Window( [200, 0, 400, 200] );
% w = ptb.Window();

rect = ptb.stimuli.Rect( w );

img_mat = imread( ptb.util.respath('textures/image.jpeg') );

open( w );
open( w2 );

image = ptb.Image( w, img_mat );

rect.FaceColor = [255, 0, 255];
rect.Scale = [50, 50];
rect.Position.Units = 'normalized';
rect.Scale.Units = 'px';

rect2 = clone( rect );
rect3 = clone( rect );
rect3.Position.Units = 'px';
rect3.Scale = [ 5, 5 ];

source = ptb.MouseSource( w2 );
sampler = ptb.samplers.Pass( source );

target = ptb.XYTarget( sampler, ptb.bounds.Rect(ptb.rects.MatchRectangle(rect)) );
target2 = ptb.XYTarget( sampler, ptb.bounds.EncircleRect(ptb.rects.MatchRectangle(rect2)) );

updater = ptb.ComponentUpdater();
add_components( updater, source, sampler, target, target2 );

frame_timer = ptb.FrameTimer();

while ( ~ptb.util.is_esc_down() )
  update( updater );
  
  if ( target.IsInBounds )
    rect.FaceColor = image;
    rect2.FaceColor = [ 0, 0, 255 ];
  else
    rect.FaceColor = [ 255, 0, 0 ];
    rect2.FaceColor = [ 0, 255, 0 ];
  end
  
  if ( target2.IsInBounds )
    rect.FaceColor = [ 0, 255, 255 ];
    rect2.FaceColor = image;
  end
  
  rect.Position = [ 1/3, 0.5 ];
  rect2.Position = [ 2/3, 0.5 ];
  rect3.Position = [ sampler.X, sampler.Y ];
  
  draw( rect, w );
  draw( rect, w2 );
  draw( rect2, w );
  draw( rect2, w2 );
  draw( target2.Bounds, w );
  draw( target.Bounds, w );
  draw( rect3, w );
  
  flip( w );
  flip( w2 );
  
  update( frame_timer );
end

fprintf( '\n Mean frame: %0.3f', frame_timer.Mean );

end