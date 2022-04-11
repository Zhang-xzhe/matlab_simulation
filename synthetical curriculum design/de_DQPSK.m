function demoduled_signal = de_DQPSK(receive_signal,Fs,IF_fre,bandwidth)
%产生接收信号时间轴
t = 1:length(receive_signal);
t = t/Fs;
%产生载波信号
I_cos = cos(2*pi*IF_fre.*t);
my_sin = sin(2*pi*IF_fre.*t);
%正交相乘
I_signal = receive_signal.*I_cos;
Q_signal = receive_signal.*my_sin;
%低通滤波器截至频率计算
if mod(IF_fre*2,Fs)>Fs/2
    lowpassf = (Fs-2*IF_fre)/2;
else
    lowpassf = IF_fre;
end
%低通滤波器构造
lowpass_filter = fir1(146,2*lowpassf/Fs,"low");
demoduled_signal_I = conv(I_signal,lowpass_filter);
demoduled_signal_Q = conv(Q_signal,lowpass_filter);
t_delay = length(lowpass_filter)/2;
%时延补偿
demoduled_signal_I = demoduled_signal_I(t_delay:length(demoduled_signal_I)-t_delay);
demoduled_signal_Q = demoduled_signal_Q(t_delay:length(demoduled_signal_Q)-t_delay);
demoduled_signal = [demoduled_signal_I;demoduled_signal_Q];
end