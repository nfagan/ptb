function [centroid, area] = polygon_centroid(px, py)

% https://www.mathworks.com/matlabcentral/fileexchange/7844-geom2d

% vertex indices
N = length(px);
iNext = [2:N 1];
% compute cross products
common = px .* py(iNext) - px(iNext) .* py;
sx = sum((px + px(iNext)) .* common);
sy = sum((py + py(iNext)) .* common);
% area and centroid
area = sum(common) / 2;
centroid = [sx sy] / 6 / area;

end