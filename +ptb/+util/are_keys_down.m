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

if ( nargin == 0 )
  tf = logical( [] );
  return
end

if ( nargin == 1 )
  code_array = varargin{1};
else
  code_array = varargin;
end

[key_pressed, ~, key_code] = KbCheck();

if ( ~key_pressed )
  tf = false( size(code_array) );
  return
end

if ( nargin == 1 )
  % Code array is double.
  tf = logical( arrayfun(@(x) key_code(x), code_array) );
else
  % Code array is cell.
  tf = logical( cellfun(@(x) key_code(x), code_array) );
end

end