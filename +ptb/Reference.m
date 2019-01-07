classdef Reference < handle
  
  properties
    Value = [];
  end
  
  methods
    function obj = Reference(data)
      
      %   REFERENCE -- Give Matlab data reference-semantics.
      %
      %     obj = ptb.Reference( data ); creates a handle-class object
      %     whose Value property contains `data`. `data` can be any Matlab
      %     data type.
      %
      %     See also ptb.Task
      
      if ( nargin > 0 )
        obj.Value = data;
      end
    end
    
    function obj = set(obj, value)
      
      %   SET -- Set contents.
      %
      %     See also ptb.Reference
      
      obj.Value = value;
    end
  end
end