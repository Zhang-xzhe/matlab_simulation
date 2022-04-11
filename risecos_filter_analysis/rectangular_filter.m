%=========================================================================%
                              %矩形波成形BPSK实验
%=========================================================================%

%参数设置
Fs = 40e3;                                                                 %采样率40k
IF_fre = 10e3;                                                             %中频频率10k
symbol_rate = 1e3;                                                         %数据率1k
sample_persym = Fs/symbol_rate;                                            %每个符号的采样点数
alpha_factor = 0.25;                                                       %滚降系数
%生成数据流
data = randi([0 1],1,20);
%生成矩形波成形信号
baseband_signal = zeros(1,length(data)*sample_persym);                     
for i = 1:length(data)
    if i == 1
        baseband_signal(floor(sample_persym/2)) = data(i);
    else
        baseband_signal(floor(sample_persym/2)+sample_persym*(i-1)) = data(i);
    end
end

%载波信号时间轴
t = 1:length(shaped_signal);
t = t/Fs;
%产生载波信号
LO_cos = cos(2*pi*IF_fre.*t);
%上变频
moduled_signal = shaped_signal.*LO_cos;

figure(1)
plot(rcos_filter);
title("升余弦滚降滤波器时域")

figure(2)
t_sym = (1:length(baseband_signal))/Fs; 
t_signal = (1:length(shaped_signal))/Fs;
stem(t_sym,baseband_signal,"kx");hold on
plot(t_signal,5*shaped_signal,"b-");hold off
title("数据脉冲成形效果")

figure(3)
plot(moduled_signal)
title("BPSK调制后的信号")

figure(4)
plot(abs(fft(moduled_signal)))
title("BPSK调制后的信号频谱")
