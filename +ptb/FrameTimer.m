classdef FrameTimer < handle
  
  properties (SetAccess = private, GetAccess = public)
    %   MAX -- Maximum delta.
    %
    %     Max is a read-only double scalar giving the maximum amount of
    %     elapsed seconds between calls to `update`.
    %
    %     See also ptb.FrameTimer, ptb.FrameTimer.Min
    Max = nan;
    
    %   MIN -- Minimum delta.
    %
    %     Min is a read-only double scalar giving the minimum amount of
    %     elapsed seconds between calls to `update`.
    %
    %     See also ptb.FrameTimer, ptb.FrameTimer.Mean, ptb.FrameTimer.Max
    Min = nan;
    
    %   MEAN -- Mean delta.
    %
    %     Mean is a read-only double scalar giving the mean amount of
    %     elapsed seconds between calls to `update`.
    %
    %     See also ptb.FrameTimer, ptb.FrameTimer.Max
    Mean = nan;
    
    %   ITERATION -- Number of computed deltas.
    %
    %     Iteration is a read-only double scalar giving the number of times
    %     a delta was computed and used to update the frame time stats.
    %
    %     See also ptb.FrameTimer, ptb.FrameTimer.Mean
    Iteration = 0;
  end
  
  properties (Access = private)
    last_frame = nan;
    timer;
  end
  
  methods
    function obj = FrameTimer()
      
      %   FRAMETIMER -- Create FrameTimer object instance.
      %
      %     obj = ptb.FrameTimer() creates a FrameTimer object, used to
      %     track the average amount of time a frame takes to compute.
      %
      %     A frame in this case is one complete pass through a while loop.
      %
      %     See also ptb.FrameTimer.Mean, ptb.ComponentUpdater,
      %       ptb.FrameTimer.update
    end
  end
  
  methods (Access = public)
    function reset(obj)
      
      %   RESET -- Reset properties to defaults.
      %
      %     See also ptb.FrameTimer
      
      obj.last_frame = nan;
      obj.timer = nan;
      obj.Mean = nan;
      obj.Max = nan;
      obj.Min = nan;
      obj.Iteration = 0;
    end
    
    function update(obj)
      
      %   UPDATE -- Update frame time.
      %
      %     update( obj ) computes a delta relative to the last time
      %     `update` was called, updating the Mean, etc. properties
      %     accordingly.
      %
      %     The first call to `update` starts the timer.
      %
      %     See also ptb.FrameTimer
      
      if ( isnan(obj.last_frame) )
        obj.timer = tic();
        obj.last_frame = toc( obj.timer );
        return
      end
      
      delta = toc( obj.timer ) - obj.last_frame;
      
      if ( obj.Iteration == 0 )
        obj.Mean = delta;
        obj.Max = delta;
        obj.Min = delta;
      else
        obj.Mean = (obj.Mean * obj.Iteration + delta) / (obj.Iteration + 1);
        
        if ( delta > obj.Max )
          obj.Max = delta;
        end
        
        if ( delta < obj.Min )
          obj.Min = delta;
        end
      end
      
      obj.Iteration = obj.Iteration + 1;
    end
  end
  
end