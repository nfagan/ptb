classdef Queue < handle
  properties (GetAccess = public, SetAccess = private)
    DeviceIndex;
  end
  
  properties (Access = private)
    listeners = {};
  end
  
  methods
    function obj = Queue(device_index)
      if ( nargin == 0 )
        device_index = -1;
      end
      
      obj.DeviceIndex = device_index;
      KbQueueCreate( device_index );
    end
    
    function update(obj)
      [pressed, first_press] = KbQueueCheck( obj.DeviceIndex );
      
      if ( ~pressed )
        return
      end
      
      for i = 1:numel(obj.listeners)
        feval( obj.listeners{i}, first_press );
      end
    end
    
    function add_listener(obj, func)
      validateattributes( func, {'function_handle'}, {'scalar'}, mfilename ...
        , 'func' );
      obj.listeners{end+1} = func;
    end
    
    function start(obj)
      KbQueueStart( obj.DeviceIndex );
    end
    
    function release(obj)
      KbQueueRelease( obj.DeviceIndex );
    end
    
    function set.DeviceIndex(obj, device_index)
      validateattributes( device_index, {'double'} ...
        , {'scalar', 'finite', 'nonnan'}, mfilename, 'DeviceIndex' );
      obj.DeviceIndex = device_index;
    end
  end
end