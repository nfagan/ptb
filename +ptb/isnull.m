function tf = isnull(v)

%   ISNULL -- True if argument is a ptb.Null object.
%
%     tf = ptb.isnull( v ) returns true if `v` is a ptb.Null object, and
%     false otherwise.
%
%     See also ptb.Null
%
%     IN:
%       - `v` (/any/)
%     OUT:
%       - `tf` (logical)

tf = isa( v, 'ptb.Null' );

end