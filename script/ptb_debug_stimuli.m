w = ptb.Window( [0, 0, 200, 200] );

rect = ptb.stimuli.Rect( w );
rect.Shape = 'oval';

img_mat = imread( '/Users/Nick/Desktop/Screen Shot 2018-12-06 at 9.27.28 PM.png' );

open( w );

image = ptb.Image( w, img_mat );

rect.FaceColor = [255, 0, 255];
rect.Position = [0.5, 0.5];
rect.Scale = [100, 100];
rect.Position.Units = 'normalized';
rect.Scale.Units = 'px';

stp = 1;

while ( ~ptb.util.is_esc_down() ) 
  draw( rect );
  flip( w );
  
  if ( stp > 100 )
    rect.FaceColor = image;
  end
  
  stp = stp + 1;
end

close( w );