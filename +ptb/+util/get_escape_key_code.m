function code = get_escape_key_code()

%   GET_ESCAPE_KEY_CODE -- Get key code for escape key, cross-platform.
%
%     See also ptb.State, ptb.util.try_add_ptoolbox
%
%     OUT:
%       - `code` (double)

if ( ispc() )
  try
    code = KbName( 'esc' );
  catch err
    code = KbName( 'escape' );
  end
else
  code = KbName( 'escape' );
end

end