classdef Identifier < handle
  
  properties (Access = private)
    id;
  end
  
  methods
    function obj = Identifier()
      
      %   IDENTIFIER -- Create object representing unique id.
      %
      %     obj = ptb.Identifier(); creates an object that represents a
      %     unique identifier. Each time the constructor is called, a new,
      %     randomized id is generated. Subseqently, the eq function can be
      %     used to check if two identifiers are identical.
      %
      %     See also ptb.XYTarget
      
%       obj.id = char( java.util.UUID.randomUUID() );
      obj.id = next_numeric_id();
    end
    
    function tf = eq(obj, B)
      
      %   EQ -- True for identifiers with the same id.
      %
      %     tf = eq( A, B ) is called when either `A` or `B` is a 
      %     ptb.Identifier object. `tf` is a scalar logical indicating
      %     whether `A` and `B` are both ptb.Identifier objects with the
      %     same underlying id.
      %
      %     If `A` and `B` are ptb.Identifier object arrays, then their 
      %     sizes must match, or else one can be scalar, and the result 
      %     `tf` is the same size as the non-scalar input.
      %
      %     See also ptb.Identifier
      
      cls = 'ptb.Identifier';
      is_scalar_a = isscalar( obj );
      is_scalar_b = isscalar( B );
      
      if ( is_scalar_a && is_scalar_b )
%         tf = isa( obj, cls ) && isa( B, cls ) && strcmp( obj.id, B.id );
        tf = isa( obj, cls ) && isa( B, cls ) && obj.id == B.id;
      else
        sz_a = size( obj );
        sz_b = size( B );
        either_is_scalar = is_scalar_a || is_scalar_b;
        
        if ( ~either_is_scalar && ~isequal(sz_a, sz_b) )
          error( 'Sizes of inputs must match, or one can be scalar.' );
        end
        
%         test_func = @(a, b) isa(a, cls) && isa(b, cls) && strcmp(a.id, b.id);
        test_func = @(a, b) isa(a, cls) && isa(b, cls) && a.id == b.id;
        
        if ( either_is_scalar )
          if ( is_scalar_a )
            tf = arrayfun( @(x) test_func(obj, x), B );
          else
            tf = arrayfun( @(x) test_func(x, B), obj );
          end      
        else
          tf = arrayfun( test_func, obj, B );
        end
      end
    end
    
    function tf = ne(obj, B)
      
      %   NE -- False for identifiers with the same id.
      %
      %     See also ptb.Identifier, ptb.Identifier.eq
      
      tf = ~eq( obj, B );
    end
    
    function tf = would_remove_duplicate(obj)
      
      %   WOULD_REMOVE_DUPLICATE -- Get index of duplicated element(s).
      %
      %     tf = would_remove_duplicate( obj ), where `obj` is a ptb.Identifier
      %     object array, returns a logical array the same size of `obj` 
      %     such that obj(tf) = [] would delete elements of `obj` that
      %     appear more than once, leaving the resulting array to contain
      %     only the unique elements of `obj`.
      %
      %     See also ptb.Identifier, ptb.Identifier.eq
      
      ids = [ obj.id ];
      [~, ia] = unique( ids );
      
      tf = true( size(obj) );
      tf(ia) = false;
    end
  end
end

function id = next_numeric_id()

persistent next_id;

if ( isempty(next_id) )
  next_id = uint64( 0 );
end

id = next_id;
next_id = next_id + 1;

end