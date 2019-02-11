classdef ComponentUpdater < handle
  
  properties (Access = private, Constant = true)
    aggregate_classes = { 'ptb.XYSource', 'ptb.XYSampler', 'ptb.XYTarget' };
    aggregate_property_names = { 'Sources', 'Samplers', 'Targets' };
  end
  
  properties (GetAccess = public, SetAccess = private)
    Sources = {};
    Samplers = {};
    Targets = {};
  end
  
  methods
    function obj = ComponentUpdater()
      
      %   UPDATER -- Create ComponentUpdater object instance.
      %
      %     obj = ptb.ComponentUpdater() creates an ComponentUpdater object 
      %     -- a utility that updates an arbitrary number of source, 
      %     sampler, and target objects, in logical order.
      %
      %     Calling `update` on the object updates all sources, then all
      %     samplers, and finally all targets, avoiding potential coding
      %     errors.
      %
      %     After creating the object, use the `add_component` method to
      %     add a source, sampler, or target object to the corresponding
      %     list of to-be-updated components.
      %
      %     EXAMPLE //
      %
      %       mouse = ptb.sources.Mouse();
      %       sampler = ptb.samplers.Pass( mouse );
      %       updater = ptb.ComponentUpdater();
      %
      %       add_components( updater, mouse, sampler );
      %
      %       while ~ptb.util.is_esc_down()
      %         update( updater );
      %       end
      %
      %     See also ptb.ComponentUpdater.add_component, 
      %       ptb.ComponentUpdater.Sources
      
    end
  end
  
  methods (Access = public)
    function was_added = add_component(obj, component, force_add)
      
      %   ADD_COMPONENT -- Add updateable component.
      %
      %     add_component( obj, component ); adds `component` to the current
      %     list of ptb.XYSources, ptb.XYSamplers, or ptb.XYTargets, 
      %     according to the class of `component`, so long as it has not 
      %     already been added.
      %
      %     was_added = add_component(...) returns whether `component` was
      %     newly added to the corresponding list.
      %
      %     An error is thrown if `component` is not of one of the above
      %     types.
      %
      %     See also ptb.ComponentUpdater, 
      %       ptb.ComponentUpdater.add_components, ptb.XYSource
      %
      %     IN:
      %       - `component` (ptb.XYSource, ptb.XYSampler, ptb.XYTarget)
      %     OUT:
      %       - `was_added` (logical)
      
      if ( nargin < 3 )
        force_add = false;
      else
        validateattributes( force_add, {'logical'}, {'scalar'} ...
          , mfilename, 'check_if_should_add' );
      end
            
      classes = obj.aggregate_classes;
      props = obj.aggregate_property_names;
      N = numel( props );
      
      was_added = false;
      
      for i = 1:N
        if ( isa(component, classes{i}) )
          was_added = check_add_component( obj, component, props{i}, force_add );
          return
        end
      end
      
      validateattributes( component, obj.aggregate_classes, {} ...
        , mfilename, 'component' );
    end
    
    function was_added = add_components(obj, varargin)
      
      %   ADD_COMPONENTS -- Add arbitrary number of updateable components.
      %
      %     add_components( obj, component1, component2, ... ) adds any
      %     number of updateable components to `obj`. An error is thrown,
      %     and no components added, if any input is an invalid type.
      %
      %     See also ptb.ComponentUpdater.add_component, ptb.ComponentUpdater
      
      for i = 1:numel(varargin)
        validateattributes( varargin{i}, obj.aggregate_classes, {} ...
          , mfilename, 'a "component"', i );
      end
      
      was_added = false( size(varargin) );
      
      for i = 1:numel(varargin)
        was_added(i) = add_component( obj, varargin{i} );
      end
    end
    
    function was_removed = remove_component(obj, component)
      
      %   REMOVE_COMPONENT -- Remove registered component.
      %
      %     remove_component( obj, component ); tests whether `component`
      %     is a handle to a source, sampler, or target currently
      %     registered in `obj`. If it is, it is removed from the
      %     corresponding component list.
      %
      %     was_removed = ... indicates whether the component was actually
      %     removed.
      %
      %     See also ptb.ComponentUpdater,
      %       ptb.ComponentUpdater.add_component
      
      was_removed = true;
      
      try
        if ( check_remove_component(obj, component, 'Sources') )
          return
        elseif ( check_remove_component(obj, component, 'Samplers') )
          return
        elseif ( check_remove_component(obj, component, 'Targets') )
          return
        end
      catch
        % Ignore errors
      end
      
      was_removed = false;
    end
    
    function tf = remove_components(obj, varargin)
      
      %   REMOVE_COMPONENTS -- Remove any number of registered components.
      %
      %     remove_components( obj, component1, component2, ... ) removes
      %     components 1 to N from `obj`, if they are present in `obj`. 
      %
      %     tf = ... returns a logical array whose true elements indicate
      %     which components were removed.
      %
      %     See also ptb.ComponentUpdater,
      %     ptb.ComponentUpdater.remove_component
      
      tf = cellfun( @(x) remove_component(obj, x), varargin );
    end
    
    function reset(obj)
      
      %   RESET -- Remove all registered components.
      %
      %     See also ptb.ComponentUpdater,
      %     ptb.ComponentUpdater.add_component,
      %     ptb.ComponentUpdater.remove_component
      
      remove_components( obj, obj.Sources{:} );
      remove_components( obj, obj.Samplers{:} );
      remove_components( obj, obj.Targets{:} );
    end
    
    function unique(obj)
      
      obj.Sources = unique( obj.Sources );
      obj.Samplers = unique( obj.Samplers );
      obj.Targets = unique( obj.Targets );
    end
    
    function update(obj)
      
      %   UPDATE -- Update components.
      %
      %     update( obj ) updates each source, sampler, and target in `obj`
      %     in logical order. Sources are updated first, followed by
      %     samplers, followed by targets.
      %
      %     See also ptb.ComponentUpdater
      
      update_component_set( obj, obj.Sources );
      update_component_set( obj, obj.Samplers );
      update_component_set( obj, obj.Targets );
    end
    
    function out = create_registered(obj, ctor, varargin)
      
      %   CREATE_REGISTERED -- Create and register component.
      %
      %     component = create_registered( obj, constructor, arg1, ... argN );
      %     creates a source, sampler, or target component by calling its
      %     `constructor`, a function handle, with optional arguments
      %     `arg1` through `argN`. The component is then added to the
      %     corresponding list of updateable components.
      %
      %     See also ptb.ComponentUpdater,
      %       ptb.ComponentUpdater.add_component
      
      try
        out = ctor( varargin{:} );
      catch err
        throw( err );
      end
      
      try
        add_component( obj, out );
      catch err
        throw( err );
      end
    end
  end
  
  methods (Access = private)
    function was_added = check_add_component(obj, component, aggregate, force_add)
      
      %   CHECK_ADD_COMPONENT -- Add component if not already added.
            
      if ( force_add || ~any(cellfun(@(x) x == component, obj.(aggregate))) )
        obj.(aggregate){end+1} = component;
        was_added = true;
      else
        was_added = false;
      end
    end
    
    function was_removed = check_remove_component(obj, component, aggregate)
      
      %   CHECK_REMOVE_COMPONENT -- Remove component if it exists.
      
      check_func = @(x) x == component;
      
      is_present = cellfun( check_func, obj.(aggregate) );
      was_removed = false;
        
      if ( nnz(is_present) > 0 )
        obj.(aggregate)(is_present) = [];
        was_removed = true;
        return
      end
    end
    
    function update_component_set(obj, component_set)
      N = numel( component_set );
      
      for i = 1:N
        update( component_set{i} );
      end
    end
  end
end