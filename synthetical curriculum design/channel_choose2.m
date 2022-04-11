function receive_signal2 = channel_choose2(receive_signal,Fs,IF_fre,bandW1)
%计算截至频率
low_cut = 2*(IF_fre-bandW1/2)/Fs;
high_cut = 2*(IF_fre+bandW1/2)/Fs;
%构造滤波器
BPF = fir1(146,[low_cut, high_cut],"bandpass");
%计算时延
t_delay = length(BPF)/2;
%卷积
receive_signal2 = conv(receive_signal,BPF);
%时延补偿
receive_signal2 = receive_signal2(t_delay:length(receive_signal2)-t_delay);
end