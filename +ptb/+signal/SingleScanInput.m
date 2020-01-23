classdef SingleScanInput < handle
  properties (Access = private)
    session;
  end
  
  properties (GetAccess = public, SetAccess = private)
    
    %   LATESTSAMPLE -- Latest data sample.
    %
    %     LatestSample is a 1xN vector of raw samples acquired from the
    %     underlying DAQ session.
    %
    %     See also ptb.signal.SingleScanInput.LatestSampleTime,
    %       ptb.signal.SingleScanInput
    LatestSample = zeros( 1, 0 );
    
    %   LATESTSAMPLETIME -- Timestamp of latest data sample.
    %
    %     See also ptb.signal.SingleScanInput.LatestSample,
    %       ptb.signal.SingleScanInput
    LatestSampleTime = nan;
  end
  
  methods
    function obj = SingleScanInput(session)
      
      %   SINGLESCANINPUT -- Create SingleScanInput object instance.
      %
      %     obj = ptb.signal.SingleScanInput( session ); creates an
      %     interface for obtaining samples from a DAQ `session` in an
      %     immediate-mode / on-demand fashion. That is, single samples are 
      %     only acquired upon explicit request.
      %
      %     See also ptb.signal.SingleScanInput.LatestSample,
      %       ptb.signal.SingleScanInput.update
      
      validateattributes( session, {'daq.Session'}, {'scalar'} ...
        , mfilename, 'session' );
      obj.session = session;
    end
    
    function s = get_latest_sample(obj)
      
      %   GET_LATEST_SAMPLE -- Return the LatestSample property value.
      %
      %     See also ptb.signal.SingleScanInput,
      %       ptb.signal.SingleScanInput.LatestSample
      
      s = obj.LatestSample;
    end
    
    function update(obj)
      
      %   UPDATE -- Acquire latest sample.
      %
      %     update( obj ); obtains the latest single-scan input sample from
      %     the underlying DAQ session, and stores the sample (along
      %     with its timestamp) in the LatestSample and LatestSampleTime
      %     properties.
      %
      %     See also ptb.signal.SingleScanInput
      
      [v, trigger_time] = inputSingleScan( obj.session );
      obj.LatestSample = v;
      obj.LatestSampleTime = trigger_time;
    end
  end
end