function tf = are_keys_down(varargin)

%   ARE_KEYS_DOWN -- True for keys given by key-codes that are down.
%
%     tf = ptb.util.are_keys_down( code1, code2, ... codeN ) returns a 1xN
%     logical array whose true values indicate that the key given by the
%     corresponding code is down.
%
%     See also KbName, ptb.util.is_key_down
%
%     IN:
%       - `codes` (numeric)
%     OUT:
%       - `tf` (logical)

[key_pressed, ~, key_code] = KbCheck();

if ( ~key_pressed )
  tf = false( size(varargin) );
  return
end

tf = logical( cellfun(@(x) key_code(x), varargin) );

end