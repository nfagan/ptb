classdef FrameTimer < handle
  
  properties (Access = private)
    last_frame = nan;
    timer;
  end
  
  properties (SetAccess = private, GetAccess = public)
    Mean = nan;
    Iteration = 1;
  end
  
  methods
    function obj = FrameTimer()
    end
  end
  
  methods (Access = public)
    function reset(obj)
      obj.last_frame = nan;
      obj.timer = nan;
    end
    
    function update(obj)
      
      if ( isnan(obj.last_frame) )
        obj.timer = tic();
        obj.last_frame = toc( obj.timer );
        return
      end
      
      delta = toc( obj.timer ) - obj.last_frame;
      
      if ( obj.Iteration == 1 )
        obj.Mean = delta;
      else
        obj.Mean = (obj.Mean * obj.Iteration + delta) / (obj.Iteration + 1);
      end
      
      obj.Iteration = obj.Iteration + 1;
    end
  end
  
end