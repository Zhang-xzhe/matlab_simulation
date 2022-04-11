%=========================================================================%
                              %升余弦滤波器实验
%=========================================================================%

%参数设置
Fs = 80e3;                                                                 %采样率40k
IF_fre = 10e3;                                                             %中频频率10k
symbol_rate = 1e3;                                                         %数据率1k
bandW = symbol_rate*2;                                                     %射频带宽为基带带宽的两倍
sample_persym = Fs/symbol_rate;                                            %每个符号的采样点数
alpha_factor = 1;                                                          %滚降系数
%生成数据流
data = randi([0 1],1,20);
%符号映射
for i = 1:length(data)
    if data(i) == 0
        data(i) = -1;
    end
end
%生成冲激信号
baseband_signal = zeros(1,length(data)*sample_persym);                     
for i = 1:length(data)
    if i == 1
        baseband_signal(floor(sample_persym/2)) = data(i);
    else
        baseband_signal(floor(sample_persym/2)+sample_persym*(i-1)) = data(i);
    end
end
%设计升余弦滚降滤波器
rcos_filter = rcosdesign(alpha_factor,16,sample_persym,"normal");
%计算时延
t_delay = length(rcos_filter)/2;
%脉冲成形
shaped_signal = cconv(rcos_filter,baseband_signal);
%时延补偿
shaped_signal = shaped_signal(t_delay:end-t_delay);

%矩形波成形信号
baseband_signal2 = zeros(1,length(data)*sample_persym); 
for i = 1:length(data)
    for j = 1:sample_persym
        baseband_signal2((i-1)*sample_persym+j) = data(i);
    end
end
shaped_signal2 = baseband_signal2;

%载波信号时间轴
t = 1:length(shaped_signal);
t = t/Fs;
%产生载波信号
LO_cos = cos(2*pi*IF_fre.*t);
%升余弦脉冲成形上变频
moduled_signal = shaped_signal.*LO_cos;
%矩形波成形上变频
moduled_signal2 = shaped_signal2.*LO_cos;

%%%%%输出滤波器
%计算截至频率
low_cut = 2*(IF_fre-bandW/2)/Fs;
high_cut = 2*(IF_fre+bandW/2)/Fs;
%构造滤波器
BPF = fir1(146,[low_cut, high_cut],"bandpass");
%计算时延
t_delay = length(BPF)/2;

%升余弦成形波形过带通滤波器
receive_signal = conv(moduled_signal,BPF);
%时延补偿
receive_signal = receive_signal(t_delay:length(receive_signal)-t_delay);

%矩形波成形波形过带通滤波器
receive_signal2 = conv(moduled_signal2,BPF);
%时延补偿
receive_signal2 = receive_signal2(t_delay:length(receive_signal2)-t_delay);


%==========================================================================


%产生接收信号时间轴
t = 1:length(receive_signal);
t = t/Fs;
%产生载波信号
LO_cos = cos(2*pi*IF_fre.*t);
%正交相乘
de_signal = receive_signal.*LO_cos;
%低通滤波器截至频率计算
lowpassf = IF_fre;
%低通滤波器构造
lowpass_filter = fir1(146,2*lowpassf/Fs,"low");
%升余弦过滤波器
demoduled_signal = conv(de_signal,lowpass_filter);
%计算时延
t_delay = length(lowpass_filter)/2;
%时延补偿
demoduled_signal = demoduled_signal(t_delay:length(demoduled_signal)-t_delay);

%正交相乘
de_signal2 = receive_signal2.*LO_cos;
%矩形波过滤波器
demoduled_signal2 = conv(de_signal2,lowpass_filter);
%计算时延
t_delay = length(lowpass_filter)/2;
%时延补偿
demoduled_signal2 = demoduled_signal2(t_delay:length(demoduled_signal2)-t_delay);




figure(1)
plot(rcos_filter);
xlim([1 1281]);
title("升余弦滚降滤波器时域——alpha = 1")

figure(2)
t_sym = (1:length(baseband_signal))/Fs; 
t_signal = (1:length(shaped_signal))/Fs;
stem(t_sym,baseband_signal,"kx");hold on
plot(t_signal,5*shaped_signal,"b-");hold off
xlabel("t/s")
title("数据脉冲成形效果——alpha = 0")

figure(3)
t_signal = (1:length(moduled_signal))/Fs;
plot(t_signal,moduled_signal)
xlabel("t/s")
title("升余弦成形BPSK调制后的信号")

figure(4)
spectrum = abs(fft(moduled_signal));
f = 1:length(moduled_signal);
f = f*Fs/length(moduled_signal);
plot(f,spectrum)
xlim([0 Fs]);
xlabel("f/Hz")
ylabel("Amplitude")
title("升余弦成形BPSK调制后的信号频谱")

figure(5)
t_sym = (1:length(baseband_signal))/Fs; 
t_signal = (1:length(shaped_signal2))/Fs;
stem(t_sym,baseband_signal,"kx");hold on
plot(t_signal,shaped_signal2,"b-");hold off
xlabel("t/s")
title("矩形波成形效果")

figure(6)
t_signal = (1:length(moduled_signal2))/Fs;
plot(t_signal,moduled_signal2)
xlabel("t/s")
title("矩形波成形BPSK调制后的信号")

figure(7)
spectrum = abs(fft(moduled_signal2));
f = 1:length(moduled_signal2);
f = f*Fs/length(moduled_signal2);
plot(f,spectrum)
xlim([0 Fs]);
xlabel("f/Hz")
ylabel("Amplitude")
title("矩形波成形BPSK调制后的信号频谱")

figure(8)
t_signal = (1:length(receive_signal))/Fs;
plot(t_signal,receive_signal)
xlabel("t/s")
title("升余弦成形BPSK调制后的信号-过信道后")

figure(9)
spectrum = abs(fft(receive_signal));
f = 1:length(receive_signal);
f = f*Fs/length(receive_signal);
plot(f,spectrum)
xlim([0 Fs]);
xlabel("f/Hz")
ylabel("Amplitude")
title("升余弦成形BPSK调制后的信号频谱-过信道后")

figure(10)
t_signal = (1:length(receive_signal2))/Fs;
plot(t_signal,receive_signal2)
xlabel("t/s")
title("矩形波成形BPSK调制后的信号-过信道后")

figure(11)
spectrum = abs(fft(receive_signal2));
f = 1:length(receive_signal2);
f = f*Fs/length(receive_signal2);
plot(f,spectrum)
xlim([0 Fs]);
xlabel("f/Hz")
ylabel("Amplitude")
title("矩形波成形BPSK调制后的信号频谱-过信道后")

figure(12)
t_sym = (1:length(baseband_signal))/Fs; 
t_signal = (1:length(shaped_signal2))/Fs;
stem(t_sym,baseband_signal,"kx");hold on
plot(t_signal,5*demoduled_signal,"b-");hold off
xlabel("t/s")
title("升余弦成形BPSK解调后的信号")

figure(13)
t_sym = (1:length(baseband_signal))/Fs; 
t_signal = (1:length(shaped_signal2))/Fs;
stem(t_sym,baseband_signal,"kx");hold on
plot(t_signal,demoduled_signal2,"b-");hold off
xlabel("t/s")
title("矩形波成形BPSK解调后的信号")

%矩形波时域
rectagular_signal = zeros(1,length(rcos_filter));
for i = 1:length(rcos_filter)
    if i<(length(rcos_filter)+sample_persym)/2&&i>(length(rcos_filter)-sample_persym)/2
        rectagular_signal(i) = 1;
    end
end

figure(14)
plot(rectagular_signal);
xlim([1 1281]);
title("矩形波时域")

figure(15)
spectrum = abs(fftshift(fft(rectagular_signal)));
f = 1:length(rectagular_signal);
f = f*Fs/length(rectagular_signal);
plot(f,spectrum)
xlim([0 Fs]);
xlabel("f/Hz")
ylabel("Amplitude")
title("矩形波频域")

figure(16)
spectrum = abs(fftshift(fft(rcos_filter)));
f = 1:length(rcos_filter);
f = f*Fs/length(rcos_filter);
plot(f,spectrum)
xlim([0 Fs]);
xlabel("f/Hz")
ylabel("Amplitude")
title("升余弦滤波器频域——alpha = 1")
