classdef Reference < handle
  
  properties
    Value = [];
  end
  
  properties (Access = public, Transient = true)
    
    %   DESTRUCT -- Delete function.
    %
    %     Destruct is a handle to a function that is called upon object
    %     deletion. The function should accept a single input -- the
    %     Reference object instance -- and return no outputs.
    %
    %     See also ptb.Reference
    Destruct = @(varargin) 1;
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
    
    function obj = set_value(obj, value)
      
      %   SET -- Set contents.
      %
      %     See also ptb.Reference
      
      obj.Value = value;
    end
    
    function set.Destruct(obj, v)
      validateattributes( v, {'function_handle'}, {'scalar'}, mfilename, 'Destruct' );
      obj.Destruct = v;      
    end
    
    function delete(obj)
      
      %   DELETE -- Object destructor.
      %
      %     See also ptb.Reference.Destruct
      
      try
        obj.Destruct( obj );
      catch err
        warning( err.message );
      end
    end
  end
end