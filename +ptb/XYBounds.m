classdef XYBounds < handle
  
  methods
    function obj = XYBounds()
      
      %   XYBOUNDS -- Abstract interface to test if (X, Y) samples are in
      %     bounds.
      %
      %     ptb.XYBounds describes an interface for determining if an (X,
      %     Y) coordinate is or is not in bounds. As this class is an
      %     interface, it is not meant to be used directly; instead, refer
      %     to its subclasses for concrete implementations.
      %
      %     A ptb.XYBounds object will always have a test() method
      %     indicating whether a given coordinate is or is not considered
      %     in bounds.
      %
      %     See also ptb.XYBounds.test, ptb.bounds.Always, 
      %       ptb.bounds.Never, ptb.bounds.Circle, ptb.XYTarget
      
    end
  end
  
  methods (Abstract = true)
    %   TEST -- Test whether (X, Y) position is in bounds.
    %
    %     tf = test( obj, x, y ); returns a logical scalar value `tf`
    %     indicating whether the current (`x`, `y`) coordinate is
    %     considered in bounds.
    %
    %     Objects that subclass the ptb.XYBounds class can (must) implement
    %     this method according to their own logic.
    %
    %     See also ptb.XYTarget, ptb.XYBounds
    %
    %     @T :: [logical] = (ptb.XYBounds, double, double)
    tf = test(obj, x, y);
  end
  
end