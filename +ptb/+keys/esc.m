function code = esc()

%   ESC -- Get key code for escape key, cross-platform.
%
%     See also ptb.util.try_add_ptoolbox
%
%     OUT:
%       - `code` (double)

persistent store_code;

if ( isempty(store_code) )
  if ( ispc() )
    try
      code = KbName( 'esc' );
    catch err
      code = KbName( 'escape' );
    end
  else
    code = KbName( 'escape' );
  end
  
  store_code = code;
end

code = store_code;

end