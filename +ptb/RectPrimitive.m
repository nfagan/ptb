classdef RectPrimitive
  
  methods
    function obj = RectPrimitive()
      
      %   RECTPRIMITIVE -- Abstract superclass of ptb.Rect objects.
      %
      %     ptb.RectPrimitive describes an interface for an object that
      %     represents a rect -- conceptually, a 4-element vector with
      %     minimum x, minimum y, maximum x, and maximum y components.
      %
      %     Objects that implement the ptb.RectPrimitive interface have a
      %     get() method that returns the 4-element rect vector.
      %
      %     See also ptb.Rect, ptb.rects.MatchRectangle
      
    end
  end
  
  methods (Access = public, Abstract = true)
    get(obj);
  end
  
  methods (Access = public)
    function r = get_window_dependent(obj, window)
      r = get( obj );
    end
  end
  
end