function receive_signal3 = channel_choose3(receive_signal,Fs,IF_fre,bandW3)
%计算截至频率
high_cut = 2*(IF_fre+bandW3/2)/Fs;
%构造滤波器
LPF = fir1(146,high_cut,"low");
%计算时延
t_delay = length(LPF)/2;
%卷积
receive_signal3 = conv(receive_signal,LPF);
%时延补偿
receive_signal3 = receive_signal3(t_delay:length(receive_signal3)-t_delay);
end