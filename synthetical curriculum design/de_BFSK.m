function deBFSK_bits = de_BFSK(receive_signal,Fs,IF_fre,BFSK_delta)
%产生时间轴
t = 1:length(receive_signal);
t = t/Fs;
%产生载波信号
signal = cos(2*pi*IF_fre*t);
%乘法器
deBFSK_bits = signal.*receive_signal;
%滤波器设计
LPF = fir1(146,2*BFSK_delta/Fs,"low");
%时延计算
t_delay = length(LPF)/2;
%滤波

deBFSK_bits = conv(LPF,deBFSK_bits);
deBFSK_bits = deBFSK_bits(t_delay:length(receive_signal)-t_delay);
deBFSK_bits = abs(deBFSK_bits);
deBFSK_bits = conv(LPF,deBFSK_bits);
deBFSK_bits = deBFSK_bits(t_delay:length(receive_signal)-t_delay);

end