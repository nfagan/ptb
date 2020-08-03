% See also ptb.bounds.Always.Always
% @T import ptb.types
classdef Always < ptb.XYBounds
  
  methods
    function obj = Always()
      
      %   ALWAYS -- Always in bounds.
      %
      %     obj = ptb.bounds.Always() returns an object whose `test` method
      %     always returns true.
      %
      %     See also ptb.XYBounds, ptb.XYBounds.test
      
      % @T cast ptb.bounds.Always
      obj = obj@ptb.XYBounds();
    end
  end
  
  methods (Access = public)
    % @T :: [logical] = (ptb.bounds.Always, double, double)
    function tf = test(obj, x, y)
      tf = true;
    end
  end
end