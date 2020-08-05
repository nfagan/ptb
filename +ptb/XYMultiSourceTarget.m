% See also ptb.XYMultiSourceTarget/XYMultiSourceTarget
% @T import ptb.XYSampler
% @T import ptb.XYBounds
classdef XYMultiSourceTarget < handle
  
  properties (GetAccess = public, SetAccess = private)
    Samplers = {};
  end
  
  properties (Access = public)    
    %   BOUNDS -- Object defining target boundaries.
    %
    %     Bounds is a handle to an object that is a subclass of
    %     ptb.XYBounds, and is used to determine whether the current (X, Y) 
    %     sample is in bounds of the target.
    %
    %     The object should implement a public method called `test` that 
    %     receives, in addition to the object instance, the current X and Y
    %     coordinate and returns a logical scalar value indicating whether 
    %     that coordinate is "in bounds".
    %
    %     In this way, you can define e.g. a polygon with an arbitrary
    %     number of vertices, and test whether a coordinate is in bounds of
    %     that polygon.
    %
    %     For debugging and other purposes, see also ptb.bounds.Never, and
    %     ptb.bounds.Always, which report coordinates as being never and
    %     always in bounds, respectively.
    %
    %     See also ptb.XYBounds, ptb.XYMultiSourceTarget, 
    %       ptb.XYMultiSourceTarget.Samplers, ptb.bounds.Always, 
    %       ptb.bounds.Never, ptb.XYMultiSourceTarget.IsInBounds
    %
    %     @T :: ptb.XYBounds
    Bounds = ptb.bounds.Never();
    
    %   DURATION -- Amount of cumulative time to be spent in bounds.
    %
    %     Duration is a non-negative scalar number indicating the amount of
    %     time in seconds that must be spent in bounds before the
    %     IsDurationMet property is set to true. Default is Inf.
    %
    %     See also ptb.XYMultiSourceTarget, ptb.XYMultiSourceTarget.IsDurationMet
    %
    %     @T :: double
    Duration = inf;
    
    %   ENTRY -- Entry function.
    %
    %     Entry is a handle to a function that is called once upon entering
    %     the target bounds. The function should accept two arguments
    %     -- the target object instance, and the handle to the sampler 
    %     which entered the target -- and return no outputs.
    %
    %     See also ptb.XYMultiSourceTarget, ptb.XYMultiSourceTarget.Exit, 
    %       ptb.XYMultiSourceTarget.Bounds
    %
    %     @T :: [?] = (?)
    Entry = @(varargin) 1;
    
    %   EXIT -- Exit function.
    %
    %     Exit is a handle to a function that is called once upon exiting
    %     the target bounds. The function should accept two arguments
    %     -- the target object instance, and the handle to the sampler 
    %     which exited the target -- and return no outputs.
    %
    %     See also ptb.XYMultiSourceTarget, ptb.XYMultiSourceTarget.Exit, 
    %       ptb.XYMultiSourceTarget.Bounds
    %
    %     @T :: [?] = (?)
    Exit = @(varargin) 1;
  end
  
  properties (GetAccess = public, SetAccess = private)
    %   ISINBOUNDS -- True if the current sample is considered in bounds.
    %
    %     ISINBOUNDS is a read-only logical scalar indicating whether the
    %     most recent (X, Y) coordinate was considered in bounds.
    %
    %     See also ptb.XYMultiSourceTarget, ptb.XYMultiSourceTarget.Bounds
    %
    %     @T :: logical
    IsInBounds = [];
    
    %   ISDURATIONMET -- True if Cumulative is greater than Duration.
    %
    %     ISDURATIONMET is a read-only logical scalar indicating whether
    %     the Cumulative amount of time spent in bounds is greater than the
    %     current Duration.
    %
    %     See also ptb.XYMultiSourceTarget, ptb.XYMultiSourceTarget.Duration,
    %       ptb.XYMultiSourceTarget.Cumulative
    %
    %     @T :: logical
    IsDurationMet = [];
    
    %   CUMULATIVE -- Total amount of consecutive time spent in bounds.
    %
    %     Cumulative is a read-only number giving the total amount of time
    %     spent consecutively in bounds of the target, in seconds. It is 
    %     reset to 0 whenever a sample is considered to be not in bounds, 
    %     or after a call to the `reset` function.
    %
    %     See also ptb.XYMultiSourceTarget, ptb.XYMultiSourceTarget.reset
    %
    %     @T :: double
    Cumulative = [];
  end
  
  properties (Access = private)
    % @T :: double
    last_frame = nan;
    % @T :: double
    cumulative_timer;
    % @T :: logical
    did_enter = [];
  end
  
  methods
    function obj = XYMultiSourceTarget(sampler, bounds)
      
      %   XYMultiSourceTarget -- Create XYMultiSourceTarget object instance.
      %
      %     XYMultiSourceTarget objects keep track of whether and for how 
      %     long (X, Y) coordinates from multiple sources are in bounds 
      %     of a target. 
      %
      %     obj = ptb.XYMultiSourceTarget( sampler ); creates an 
      %     XYMultiSourceTarget whose coordinates are drawn from `sampler`, 
      %     a subclass of ptb.XYSampler such as ptb.samplers.Pass. The 
      %     Bounds property of  `obj`, which tests whether a coordinate 
      %     from `sampler` is in  bounds, is set to an object that never 
      %     returns true.
      %
      %     obj = ptb.XYMultiSourceTarget( ..., bounds ) creates the object 
      %     and sets the Bounds property to `bounds`. `bounds` must be a 
      %     subclass of ptb.XYBounds.
      %
      %     See also ptb.XYMultiSourceTarget.Bounds, 
      %       ptb.XYMultiSourceTarget.Samplers,
      %       ptb.XYMultiSourceTarget.Duration, ptb.XYBounds
      
      if ( nargin > 0 )
        obj.Samplers{end+1} = sampler;
      end
      
      if ( nargin > 1 )
        obj.Bounds = bounds;
      end
      
      obj.cumulative_timer = tic;
      obj.reset();
    end
    
    % @T :: [] = (ptb.XYMultiSourceTarget, ptb.XYBounds)
    function set.Bounds(obj, v)
      validateattributes( v, {'ptb.XYBounds'}, {'scalar'}, mfilename, 'Bounds' );
      obj.Bounds = v;
    end
    
    % @T :: [] = (ptb.XYMultiSourceTarget, double)
    function set.Duration(obj, v)
      validateattributes( v, {'numeric'}, {'scalar', 'nonnegative'} ...
        , mfilename, 'Duration' );
      obj.Duration = double( v );
    end
  end
  
  methods (Access = public)
    function add_sampler(obj, sampler)
      validateattributes( sampler, {'ptb.XYSampler'} ...
        , {'scalar'}, mfilename, 'sampler' );
      already_exists = sum( cellfun(@(x) x == sampler, obj.Samplers) ) == 1;
      
      if ( ~already_exists )
        obj.Samplers{end+1} = sampler;
        obj.reset();
      end
    end
    
    function reset(obj)
      
      %   RESET -- Reset the Cumulative amount of time spent in bounds.
      %
      %     See also ptb.XYMultiSourceTarget, ptb.XYMultiSourceTarget.Cumulative,
      %       ptb.XYMultiSourceTarget.Duration
      
      obj.Cumulative = zeros( 1, numel(obj.Samplers) );
      obj.last_frame = toc( obj.cumulative_timer );
      obj.IsDurationMet = false( 1, numel(obj.Samplers) );
      obj.IsInBounds = false( 1, numel(obj.Samplers) );
      
      obj.did_enter = false( 1, numel(obj.Samplers) );
    end
    
    function update(obj)
      
      %   UPDATE -- Update the in-bounds state of the XYTarget.
      %
      %     update( obj ) checks whether the current sample is in bounds,
      %     and if so, updates the Cumulative total amount of time spent in
      %     bounds.
      %
      %     This function is most sensibly called in a loop after updating 
      %     the underlying source's position.
      %
      %     See also ptb.XYMultiSourceTarget,
      %       ptb.XYMultiSourceTarget.Samplers
      
      num_samplers = numel( obj.Samplers );
      is_in_bounds = false( num_samplers, 1 );
      
      for i = 1:num_samplers
        sampler = obj.Samplers{i};
        is_useable_sample = sampler.IsValidSample;
        
        if ( is_useable_sample )
          is_in_bounds(i) = test( obj.Bounds, sampler.X, sampler.Y );
        end
      end
      
      current_frame = toc( obj.cumulative_timer );
      
      for i = 1:num_samplers
        if ( is_in_bounds(i) && ~isnan(obj.last_frame) )
          delta = current_frame - obj.last_frame;
          obj.Cumulative(i) = obj.Cumulative(i) + delta;
        else
          obj.Cumulative(i) = 0;
        end
        
        should_call_entry = is_in_bounds(i) && ~obj.did_enter(i);
        should_call_exit = ~is_in_bounds(i) && obj.did_enter(i);

        if ( should_call_entry )
          obj.Entry( obj, obj.Samplers{i} );
          obj.did_enter(i) = true;
          
        elseif ( should_call_exit )
          obj.Exit( obj, obj.Samplers{i} );
          obj.did_enter(i) = false;
        end
      end
      
      obj.IsInBounds = is_in_bounds;
      obj.IsDurationMet = obj.Cumulative >= obj.Duration;
      
      obj.last_frame = current_frame;
    end
  end
end