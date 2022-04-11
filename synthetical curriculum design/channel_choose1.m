function receive_signal1 = channel_choose1(receive_signal,Fs,IF_fre,bandW1)
%计算截至频率
low_cut = 2*(IF_fre-bandW1/2)/Fs;
%构造滤波器
HPF = fir1(146,low_cut,"high");
%计算时延
t_delay = length(HPF)/2;
%卷积
receive_signal1 = conv(receive_signal,HPF);
%时延补偿
receive_signal1 = receive_signal1(t_delay:length(receive_signal1)-t_delay);
end