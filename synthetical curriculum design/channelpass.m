function receive_signal = channelpass(IF_signal,Fs,passband_filter_order,IF_fre,passband_w,noise_strength)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            说明
%              本信道为带有带通高斯噪声的带通信道
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
signal_length = length(IF_signal);                                         %采样点数
noise_signal = noise_strength.*randn(1,signal_length);                     %产生高斯白噪声
receive_signal = noise_signal+IF_signal;                                   %信号叠加高斯白噪声

low_cutoff_fre = IF_fre-0.5*passband_w;                                    %计算低端截至频率
high_cutoff_fre = IF_fre+0.5*passband_w;                                   %计算高端截止频率
Wn = [2*low_cutoff_fre/Fs,2*high_cutoff_fre/Fs];                           %计算滤波器系数
filter = fir1(passband_filter_order,Wn,"bandpass");                        %产生带通滤波器
t_delay = length(filter)/2;                                                %计算滤波器时延
receive_signal = conv(receive_signal,filter);                              %对信号进行滤波
receive_signal = receive_signal(t_delay:length(receive_signal)-t_delay);   %时延补偿

% figure(3)
% plot(receive_signal)
end