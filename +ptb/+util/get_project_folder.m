function p = get_project_folder()

%   GET_PROJECT_FOLDER -- Get folder containg +ptb folder.
%
%     See also ptb.util.try_add_ptoolbox

fp = @fileparts;
p = fp( fp(fp(which('ptb.util.get_project_folder'))) );

end