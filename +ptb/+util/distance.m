function d = distance(x0, y0, x1, y1)

%   DISTANCE -- Distance between two points or sets of points.
%
%     d = ptb.util.distance( x0, y0, x1, y1 ); gives the distance between
%     points 0 and 1.
%
%     See also ptb.bounds.Circle
%
%     IN:
%       - `x0` (double)
%       - `y0` (double)
%       - `x1` (double)
%       - `y1` (double)
%     OUT:
%       - `d` (double)

d = sqrt( (x1 - x0).^2 + (y1 - y0).^2 );

end