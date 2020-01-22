classdef LinearlyMappedInterval
  properties (Access = public)
    
    %   SOURCEINTERVAL -- Interval of values to be mapped from.
    %
    %     See also ptb.util.LinearlyMappedInterval.MappedInterval,
    %       ptb.util.LinearlyMappedInterval
    SourceInterval;
    
    %   MAPPEDINTERVAL -- Interval of mapped-to values.
    %
    %     See also ptb.util.LinearlyMappedInterval.MappedInterval,
    %       ptb.util.LinearlyMappedInterval
    MappedInterval;
  end
  
  methods
    function obj = LinearlyMappedInterval(source_interval, mapped_interval)
      
      %   LINEARLYMAPPEDINTERVAL -- Create LinearlyMappedInterval object instance.
      %
      %     obj = ptb.util.LinearlyMappedInterval( source_interval, mapped_interval );
      %     creates an interface for linearly mapping values in a 
      %     `source_interval` to their corresponding values in a
      %     `mapped_interval`.
      %
      %     See also ptb.util.LinearlyMappedInterval.apply
      
      obj.SourceInterval = source_interval;
      obj.MappedInterval = mapped_interval;
    end
    
    function obj = set.SourceInterval(obj, v)
      import ptb.util.LinearlyMappedInterval;
      LinearlyMappedInterval.validate_range( v, 'SourceInterval' );
      obj.SourceInterval = v(:)';
    end
    
    function obj = set.MappedInterval(obj, v)
      import ptb.util.LinearlyMappedInterval;
      LinearlyMappedInterval.validate_range( v, 'MappedInterval' );
      obj.MappedInterval = v(:)';
    end
    
    function m = apply(obj, s)
      
      %   APPLY -- Apply mapping to source value.
      %
      %     m = apply( obj, s ); remaps the value `s` in SourceInterval
      %     to its corresponding value in MappedInterval.
      %
      %     See also ptb.util.LinearlyMappedInterval, 
      %       ptb.util.LinearlyMappedInterval.SourceInterval
      
      source_lims = obj.SourceInterval;
      
      source_range = source_lims(2) - source_lims(1);
      mapped_range = obj.MappedInterval(2) - obj.MappedInterval(1);
      
      rel = ptb.util.clamp( (s - source_lims(1)) ./ source_range, 0, 1 );
      m = rel .* mapped_range + obj.MappedInterval(1);
    end
  end
  
  methods (Access = public, Static = true)
    function validate_range(v, param_name)
      validateattributes( v, {'double'}, {'numel', 2, 'nonnan', 'finite'} ...
        , mfilename, param_name );
      assert( v(1) < v(2), 'Expected %s to be a valid range with v(1) < v(2)' ...
        , param_name );
    end
  end
end