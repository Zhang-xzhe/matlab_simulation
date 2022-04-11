function deIQ_signal = IQ_demodule(receive_signal,Fs,IF_fre)

%输入时间轴
t = 1:length(receive_signal);
t = t/Fs;
%正交载波的产生
I_signal = cos(2*pi*IF_fre*t);
Q_signal = -sin(2*pi*IF_fre*t);
%正交载波相乘
I_de_signal = receive_signal.*I_signal;
Q_de_signal = receive_signal.*Q_signal;
figure(8096)
plot(Q_de_signal)
figure(2096)
plot(abs(fft(Q_de_signal)))
%低通滤波器设置
de_lowpass = fir1(46,IF_fre/Fs,"low");
t_delay = length(de_lowpass)/2;
%滤波后得到基带信号
I_fil_signal = conv(de_lowpass,I_de_signal);
Q_fil_signal = conv(de_lowpass,Q_de_signal);
%时延补偿
I_fil_signal = I_fil_signal(t_delay:length(I_fil_signal)-t_delay);
Q_fil_signal = Q_fil_signal(t_delay:length(Q_fil_signal)-t_delay);
deIQ_signal = I_fil_signal + 1i*Q_fil_signal;
% %参数计算
% decimate_factor = Fs/symbol_rate;
% t1 = 1:length(receive_signal)/decimate_factor;
% t1 = t1/symbol_rate;
% deIQ_signal = zeros(1,length(Q_fil_signal)/decimate_factor);
% for i = 1:decimate_factor:length(Q_fil_signal)
%     deIQ_signal((i-1)/decimate_factor+1) = I_fil_signal(decimate_factor+i-1)+1i*Q_fil_signal(i+decimate_factor-1);
% end

end