% See also ptb.samplers.Void.Void
% @T import ptb.XYSource
classdef Void < ptb.XYSampler
  
  methods
    % @T :: [?] = (ptb.XYSource)
    function obj = Void(varargin)
      
      %   VOID -- Never update coordinates from Source.
      %
      %     obj = ptb.samplers.Void(); creates an XYSampler object whose
      %     coordinates are always nan, and whose IsValidSample property is
      %     always false.
      %
      %     See also ptb.XYSampler, ptb.XYSource, ptb.samplers.Missing
      
      % @T cast ptb.samplers.Void
      obj = obj@ptb.XYSampler( varargin{:} );
    end
  end
  
  methods (Access = public)
    function update(obj)
    end
  end
  
end