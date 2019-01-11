classdef Void < ptb.XYSampler
  
  methods
    function obj = Void(varargin)
      
      %   VOID -- Never update coordinates from Source.
      %
      %     obj = ptb.samplers.Void(); creates an XYSampler object whose
      %     coordinates are always nan, and whose IsValidSample property is
      %     always false.
      %
      %     See also ptb.XYSampler, ptb.XYSource, ptb.samplers.Missing
      
      obj = obj@ptb.XYSampler( varargin{:} );
    end
  end
  
  methods (Access = public)
    function update(obj)
    end
  end
  
end