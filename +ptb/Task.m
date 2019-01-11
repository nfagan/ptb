classdef Task < ptb.State
  
  properties (Access = private)
    is_new_state = false;
  end
  
  properties (Access = public, Transient = true)
    
    %   DESTRUCT -- Function to call when Task is being deleted.
    %
    %     Destruct is a handle to a function that accepts one input -- the
    %     ptb.Task instance -- and returns no outputs, and which is called 
    %     when the ptb.Task object is being deleted.
    %
    %     See also ptb.Task
    Destruct = @(varargin) 1;
  end
  
  methods
    function obj = Task()
      
      %   TASK -- Create Task instance.
      %
      %     obj = ptb.Task() creates a Task instance -- an object that runs
      %     a sequence of states, often circularly.
      %
      %     See also ptb.Task.run, ptb.State
      
      obj = obj@ptb.State();
      
      % Exit if the current state is an empty array ([]).
      add_exit_condition_empty_state( obj );
    end
    
    function set.Destruct(obj, v)
      validateattributes( v, {'function_handle'}, {'scalar'}, mfilename, 'Destruct' );
      obj.Destruct = v;      
    end
    
    function delete(obj)
      try
        obj.Destruct( obj );
      catch err
        warning( err.message );
      end
    end
  end
  
  methods (Access = public)
    function next(obj, state) %#ok
      
      %   NEXT -- Next is not defined for ptb.Task objects.
      %
      %     See also ptb.Task
      
      error( 'next() is not defined for ptb.Task objects.' );
    end
    
    function run(obj, state)
      
      %   RUN -- Run task.
      %
      %     run( obj, state ) runs the task given by `obj`, beginning in
      %     `state`. The task's Entry function is called; then, so long as
      %     a valid, non-empty next state is set, the current state is
      %     run, and the task's Loop function is called. When the next
      %     to-be-run state is empty or invalid, or an exit condition is
      %     met for the task, the Exit function is called, and execution
      %     returns to the caller.
      %
      %     See also ptb.Task, ptb.Task.next, ptb.State.Entry, 
      %       ptb.State.add_exit_condition
      %
      %     IN:
      %       - `state` (ptb.State, [])
      
      if ( obj.IsBypassed )
        bypass( obj );
        return
      end
      
      if ( nargin == 1 )
        state = [];
      end
      
      set_next( obj, state );
      
      entry( obj, false );  % false to not clear the next state
      
      called_state_loop = false;
      called_task_loop = false;
      
      while ( ~should_exit(obj) )
        loop( obj );
        
        active_state = obj.next_state;
        
        if ( active_state.IsBypassed )
          bypass( active_state );
          set_next( obj, active_state.next_state );
          continue;
        end
        
        was_new_state = obj.is_new_state;
        
        if ( was_new_state )
          entry( active_state );
          obj.is_new_state = false;
          called_state_loop = false;
        end
        
        if ( should_exit(active_state) )
          if ( ~called_state_loop )
            % Make sure we call the loop function at least once.
            loop( active_state );
          end
          
          exit( active_state );
          set_next( obj, active_state.next_state ); %#ok
        elseif ( ~was_new_state )
          loop( active_state );
          called_state_loop = true;
        end
        
        called_task_loop = true;
      end
      
      if ( ~called_task_loop )
        loop( obj );
      end
      
      exit( obj );
    end
  end
  
  methods (Access = protected)
    function set_next(obj, state)
      set_next@ptb.State( obj, state );      
      obj.is_new_state = true;
    end
  end
  
  methods (Access = private)    
    function add_exit_condition_empty_state(obj)
      add_exit_condition( obj, @() isempty(obj.next_state) );
    end
  end
end