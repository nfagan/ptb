%{

@T begin

begin export

import mt.base

import ptb.Window
import ptb.WindowDependent
import ptb.XYSource
import ptb.Null
import ptb.Rect
import ptb.types.eyelink

namespace ptb
  let MaybeWindow = ptb.Window | ptb.Null | double
end

declare function Screen :: [double, list<double>] = (list<char | double>)
declare function GetMouse :: [double, double] = (list<double>)
declare function Eyelink :: [double | ptb.EyelinkNewestFloatSample] = (char, list<integral>)
declare function WaitSecs :: [] = (double)
declare function validateattributes :: given T [] = (T, mt.cellstr, {list<integral>}, char, char)
declare function validatestring :: [char] = (char, mt.cellstr, char, char)
declare function rad2deg :: [double] = (double)

end

end

%}