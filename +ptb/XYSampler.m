% See also ptb.XYSampler.XYSampler
% @T import ptb.XYSource
% @T import ptb.types
classdef XYSampler < handle
  
  properties (Access = public)
    %   SOURCE -- Source of (X, Y) coordinates.
    %
    %     Source is a handle to an object that is a subclass of
    %     ptb.XYSource, such as ptb.sources.Mouse or ptb.sources.Eyelink. 
    %     It is the object from which (X, Y) coordinates are drawn.
    %
    %     See also ptb.XYSampler, ptb.XYSource
    %
    %     @T :: ptb.Null | ptb.XYSource
    Source = ptb.Null();
  end
  
  properties (GetAccess = public, SetAccess = protected)
    %   X -- Latest sampled X-coordinate.
    %
    %     See also ptb.XYSampler, ptb.XYSampler.Y,
    %       ptb.XYSampler.IsValidSample
    %
    %     @T :: double
    X = nan;
    
    %   Y -- Latest sampled Y-coordinate.
    %
    %     See also ptb.XYSampler, ptb.XYSampler.X,
    %       ptb.XYSampler.IsValidSample
    %
    %     @T :: double
    Y = nan;
    
    %   ISVALIDSAMPLE -- True if the latest sample is valid.
    %
    %     The sampler may have a different definition of validity than the
    %     underlying source. In any case, if IsValidSample is true, then
    %     the current X and Y coordinates are considered valid and
    %     ready-to-use by the consumer of those coordinates.
    %
    %     See also ptb.XYSampler, ptb.XYSampler.X
    %
    %     @T :: logical
    IsValidSample = false;
  end
  
  methods
    % @T :: [ptb.XYSampler] = (ptb.XYSource | ptb.Null)
    function obj = XYSampler(source)
      
      %   XYSAMPLER -- Abstract superclass for gaze position samplers.
      %
      %     An XYSampler is an intermediary between an XYSource and a
      %     consumer / user of that source, providing a means of processing
      %     raw samples before they are used downstream.
      %
      %     XYSamplers can be used to e.g. fill in brief loss-of-signal
      %     intervals, or apply smoothing to the raw data.
      %
      %     This class serves as an interface, and is not meant to be
      %     directly instantiated.
      %
      %     See also ptb.XYSampler.X, ptb.XYSampler.Y,
      %       ptb.XYSampler.IsValidSample, ptb.samplers.Missing,
      %       ptb.samplers.Pass
      
      if ( nargin < 1 )
        source = ptb.Null();
      end
      
      obj.Source = source;
    end
    
    % @T :: [] = (ptb.XYSampler, ptb.XYSource | ptb.Null)
    function set.Source(obj, source)
      try
        source = validate_source( obj, source );
      catch err
        throw( err );
      end
      
      obj.Source = source;
      
      on_set_source( obj, source );
    end
  end
  
  methods (Access = protected)
    
    % @T :: [] = (ptb.XYSampler, ptb.XYSource | ptb.Null)
    function on_set_source(obj, source)
      % 
    end
    
    % @T :: [ptb.XYSource | ptb.Null] = (ptb.XYSampler, ptb.XYSource | ptb.Null)
    function source = validate_source(obj, source)
      validateattributes( source, {'ptb.XYSource', 'ptb.Null'} ...
        , {'scalar'}, mfilename, 'Source' );
    end
  end
  
  methods (Abstract = true)
    
    %   UPDATE -- Update to latest sampled coordinates.
    %
    %     update( obj ); processes the latest sample from Source, and sets
    %     the X and Y properties accordingly. After the call to this
    %     function, the IsValidSample property can be used to determine if
    %     the X and Y coordinates are ready-to-use.
    %
    %     See also ptb.XYSampler, ptb.XYSampler.Source
    update(obj);
  end
  
end