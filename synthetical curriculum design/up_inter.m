function ready_signal = up_inter(moudule_signal,symbol_rate,Fs)
%参数计算
interpolation_factor = Fs/symbol_rate;
%内插前的时间轴
t = 1:length(moudule_signal);
t = t/symbol_rate;
%内插后的时间轴
t1 = 1:length(moudule_signal)*interpolation_factor;
t1 = t1/Fs;
%内插
ready_signal = interp1(t,moudule_signal,t1,"spline");

% baseband = zeros(1,length(moudule_signal)*interpolation_factor);
% 
% for i = 1:length(moudule_signal)
%     baseband(i*interpolation_factor) = moudule_signal(i);
% end
%低通滤波器
% LPF = designfilt('lowpassfir','PassbandFrequency',pi/interpolation_factor, ...
%          'StopbandFrequency',2*pi/interpolation_factor,'PassbandRipple',0.5, ...
%          'StopbandAttenuation',65,'DesignMethod','kaiserwin');
%LPF = fir1(46,pi/interpolation_factor,"low");
% baseband = filtfilt(LPF,baseband);
end