%{

@T begin export

namespace ptb
  record EyelinkNewestFloatSample
    gx: double
    gy: double
    pa: double
  end
  record EyelinkInitDefaults
    MISSING_DATA: double
  end
end

declare function EyelinkInitDefaults :: [ptb.EyelinkInitDefaults] = ()

end

%}