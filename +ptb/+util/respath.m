function p = respath(varargin)

%   RESPATH -- Get resource path.
%
%     p = ptb.util.respath(); returns the path to the 'res' subfolder of the
%     package directory, alongside the +ptb/ folder.
%
%     p = ptb.util.respath( 'subdir1', 'subdir2', ... ) is the same as
%     fullfile( ptb.util.resdir(), 'subdir1', 'subdir2', ... )
%
%     See also ptb.util.get_project_folder
%
%     IN:
%       - `varargin` (char)
%     OUT:
%       - `p` (char)

p = fullfile( ptb.util.get_project_folder(), 'res', varargin{:} );

end