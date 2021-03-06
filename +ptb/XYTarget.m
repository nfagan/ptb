% See also ptb.XYTarget/XYTarget
% @T import ptb.XYSampler
% @T import ptb.XYBounds
classdef XYTarget < handle
  
  properties (Access = public)
    %   SAMPLER -- Source of processed (X, Y) coordinates.
    %
    %     Sampler is a handle to an object that is a subclass of 
    %     ptb.XYSampler, and is used to obtain processed (X, Y)
    %     coordinates. In the simplest case, it can be a wrapper around a
    %     ptb.XYSource that copies the coordinates of that source, without 
    %     modifying them.
    %
    %     See also ptb.XYSampler, ptb.samplers.Pass, ptb.samplers.Missing
    %
    %     @T :: ptb.XYSampler
    Sampler = ptb.samplers.Void();
    
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
    %     See also ptb.XYBounds, ptb.XYTarget, ptb.XYTarget.Source, 
    %       ptb.bounds.Always, ptb.bounds.Never, ptb.XYTarget.IsInBounds
    %
    %     @T :: ptb.XYBounds
    Bounds = ptb.bounds.Never();
    
    %   DURATION -- Amount of cumulative time to be spent in bounds.
    %
    %     Duration is a non-negative scalar number indicating the amount of
    %     time in seconds that must be spent in bounds before the
    %     IsDurationMet property is set to true. Default is Inf.
    %
    %     See also ptb.XYTarget, ptb.XYTarget.IsDurationMet
    %
    %     @T :: double
    Duration = inf;
    
    %   ENTRY -- Entry function.
    %
    %     Entry is a handle to a function that is called once upon entering
    %     the target bounds. The function should accept a single argument
    %     -- the target object instance -- and return no outputs.
    %
    %     See also ptb.XYTarget, ptb.XYTarget.Exit, ptb.XYTarget.Bounds
    %
    %     @T :: [?] = (?)
    Entry = @(varargin) 1;
    
    %   EXIT -- Exit function.
    %
    %     Exit is a handle to a function that is called once upon exiting
    %     the target bounds. The function should accept a single argument
    %     -- the target object instance -- and return no outputs.
    %
    %     See also ptb.XYTarget, ptb.XYTarget.Exit, ptb.XYTarget.Bounds
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
    %     See also ptb.XYTarget, ptb.XYTarget.Bounds
    %
    %     @T :: logical
    IsInBounds = false;
    
    %   ISDURATIONMET -- True if Cumulative is greater than Duration.
    %
    %     ISDURATIONMET is a read-only logical scalar indicating whether
    %     the Cumulative amount of time spent in bounds is greater than the
    %     current Duration.
    %
    %     See also ptb.XYTarget, ptb.XYTarget.Duration,
    %       ptb.XYTarget.Cumulative
    %
    %     @T :: logical
    IsDurationMet = false;
    
    %   CUMULATIVE -- Total amount of consecutive time spent in bounds.
    %
    %     Cumulative is a read-only number giving the total amount of time
    %     spent consecutively in bounds of the target, in seconds. It is 
    %     reset to 0 whenever a sample is considered to be not in bounds, 
    %     or after a call to the `reset` function.
    %
    %     See also ptb.XYTarget, ptb.XYTarget.reset
    %
    %     @T :: double
    Cumulative = 0;
  end
  
  properties (Access = private)
    % @T :: double
    last_frame = nan;
    % @T :: double
    cumulative_timer;
    % @T :: logical
    did_enter = false;
  end
  
  methods
    function obj = XYTarget(sampler, bounds)
      
      %   XYTARGET -- Create XYTarget object instance.
      %
      %     XYTarget objects keep track of whether and for how long an 
      %     (X, Y) coordinate is in bounds of a target. 
      %
      %     obj = ptb.XYTarget( sampler ); creates an XYTarget whose
      %     coordinates are drawn from `sampler`, a subclass of
      %     ptb.XYSampler such as ptb.samplers.Pass. The Bounds property of 
      %     `obj`, which tests whether a coordinate from `sampler` is in 
      %     bounds, is set to an object that never returns true.
      %
      %     obj = ptb.XYTarget( ..., bounds ) creates the object and sets
      %     the Bounds property to `bounds`. `bounds` must be a subclass of
      %     ptb.XYBounds.
      %
      %     See also ptb.XYTarget.Bounds, ptb.XYTarget.Sampler,
      %       ptb.XYTarget.Duration, ptb.XYBounds
      
      if ( nargin > 0 )
        obj.Sampler = sampler;
      end
      
      if ( nargin > 1 )
        obj.Bounds = bounds;
      end
      
      obj.cumulative_timer = tic;
    end
    
    % @T :: [] = (ptb.XYTarget, ptb.XYBounds)
    function set.Bounds(obj, v)
      validateattributes( v, {'ptb.XYBounds'}, {'scalar'}, mfilename, 'Bounds' );
      obj.Bounds = v;
    end
    
    % @T :: [] = (ptb.XYTarget, ptb.XYSampler)
    function set.Sampler(obj, v)
      validateattributes( v, {'ptb.XYSampler'}, {'scalar'}, mfilename, 'Source' );
      obj.Sampler = v;
    end
    
    % @T :: [] = (ptb.XYTarget, double)
    function set.Duration(obj, v)
      validateattributes( v, {'numeric'}, {'scalar', 'nonnegative'} ...
        , mfilename, 'Duration' );
      obj.Duration = double( v );
    end
  end
  
  methods (Access = public)
    
    function reset(obj)
      
      %   RESET -- Reset the Cumulative amount of time spent in bounds.
      %
      %     See also ptb.XYTarget, ptb.XYTarget.Cumulative,
      %       ptb.XYTarget.Duration
      
      obj.Cumulative = 0;
      obj.last_frame = toc( obj.cumulative_timer );
      obj.IsDurationMet = false;
      obj.IsInBounds = false;
      
      obj.did_enter = false;
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
      %     See also ptb.XYTarget, ptb.XYTarget.Source
      
      is_useable_sample = obj.Sampler.IsValidSample;
      
      if ( is_useable_sample )
        x = obj.Sampler.X;
        y = obj.Sampler.Y;
        
        is_in_bounds = test( obj.Bounds, x, y );
      else
        is_in_bounds = false;
      end
      
      current_frame = toc( obj.cumulative_timer );
      
      if ( is_in_bounds && ~isnan(obj.last_frame) )
        delta = current_frame - obj.last_frame;
        obj.Cumulative = obj.Cumulative + delta;
      else
        obj.Cumulative = 0;
      end
      
      should_call_entry = is_in_bounds && ~obj.did_enter;
      should_call_exit = ~is_in_bounds && obj.did_enter;
      
      if ( should_call_entry )
        obj.Entry( obj );
        obj.did_enter = true;
      elseif ( should_call_exit )
        obj.Exit( obj );
        obj.did_enter = false;
      end
      
      obj.IsInBounds = is_in_bounds;
      obj.IsDurationMet = obj.Cumulative >= obj.Duration;
      
      obj.last_frame = current_frame;
    end
  end
end