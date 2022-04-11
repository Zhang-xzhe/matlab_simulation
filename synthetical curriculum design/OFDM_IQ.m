function IF_signal = OFDM_IQ(moudule_signal,IF_fre,Fs)

%时间轴
t1 = 1:length(moudule_signal);
t1 = t1/Fs;
%载波产生
I_signal_carrior = cos(2*pi*IF_fre*t1);
Q_signal_carrior = -sin(2*pi*IF_fre*t1);
%调制
I_signal = I_signal_carrior.*real(moudule_signal);
Q_signal = Q_signal_carrior.*imag(moudule_signal);
IF_signal = I_signal+Q_signal;
 end