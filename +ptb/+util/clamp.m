function v = clamp(v, lb, ub)

%   CLAMP -- Clamp input to inclusive range.
%
%     o = ptb.util.clamp( v, lb, ub ); for scalar `v` returns `lb` if 
%     `v` is less than `lb`; `ub` if `v` is greater than `ub`, and `v` 
%     otherwise.
%
%     os = ptb.util.clamp( vs, lb, ub ); for the array `vs` returns an array
%     the same size as `vs` whose elements are individually clamped as
%     above.
%
%     See also ptb.signal.LinearVoltageMapping

if ( isscalar(v) )
  if ( v < lb )
    v = lb;
  elseif ( v > ub )
    v = ub;
  end
else
  is_lt = v < lb;
  is_gt = v > ub;
  
  v(is_lt) = lb;
  v(is_gt) = ub;
end

end