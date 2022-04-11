function dehop_signal = dehop(receive_signal,Fs,IF_fre,BFSK_delta,hop_seq,hop_fre,symbol_rate)

%参数计算
signal_len = length(receive_signal);                                       %计算信号长度
symbol_num = length(hop_seq);                                              %计算跳频的总数
symbol_len = signal_len/symbol_num;                                        %每个符号的采样数
t = 1:symbol_len;                                                          %计算每个跳频的宽度
t = t/Fs;                                                                  %建立时间轴

%为跳频解调载波分配空间
hop_signal = zeros(length(hop_fre),Fs/symbol_rate);
%产生不同的载波
for k = 1:length(hop_fre)
    hop_signal(1,:) = cos(2*pi*hop_fre(k)*t);
end
%设计低通滤波器
LPF = fir1(146,2*(IF_fre+BFSK_delta)/Fs,"low");
% figure(201)
% plot(abs(fft(LPF)))
%计算补偿时延
t_delay = length(LPF)/2;
%对每一跳下变频
dehop_signal = zeros(1,signal_len);
for j = 1:symbol_num
    pros_signal = receive_signal((j-1)*symbol_len+1:j*symbol_len);         %该跳要处理的数据
%     figure(101)
%     plot(abs(fft(pros_signal)))
    de_signal = cos(2*pi*hop_fre(hop_seq(j))*t);                           %对应解调的载波
%     figure(102)
%     plot(abs(fft(de_signal)))
    to_filter_signal = pros_signal.*de_signal;                             %乘法器
%     figure(103)
%     plot(abs(fft(to_filter_signal)))
    new_signal = conv(to_filter_signal,LPF);                               %滤波
    new_signal = new_signal(t_delay:length(new_signal)-t_delay);           %时延补偿
    new_signal = new_signal./abs(new_signal);
%     figure(21)
%     plot(new_signal)
%     figure(104)
%     plot(abs(fft(new_signal)))
    dehop_signal((j-1)*symbol_len+1:j*symbol_len) = new_signal;
end
end