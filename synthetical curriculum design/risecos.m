function IF_signal = risecos(bits,alpha_factor,Fs,symbol_rate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                说明
%            本模块将比特流转为基带冲激信号，过脉冲成型滤波器
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%参数计算
sample_persym = Fs/symbol_rate;                                            %计算在相邻两帧间补0的个数
baseband_signal = zeros(1,length(bits)*sample_persym);                     %基带信号成形
for i = 1:length(bits)
    if i == 1
        baseband_signal(floor(sample_persym/2)) = bits(i);
    else
        baseband_signal(floor(sample_persym/2)+sample_persym*(i-1)) = bits(i);
    end
end
%升余弦滚降滤波器设计
rcos_filter = rcosdesign(alpha_factor,6,Fs/symbol_rate,"normal");
t_delay = length(rcos_filter)/2;
%IF_signal = upfirdn(baseband_signal,rcos_filter);

%脉冲成形
IF_signal = cconv(rcos_filter,baseband_signal);

%时延补偿
IF_signal = IF_signal(t_delay:end-t_delay);

figure(1)
plot(rcos_filter);
title("升余弦滚降滤波器时域")

figure(2)
t_sym = (1:length(baseband_signal))/Fs; 
t_signal = (1:length(IF_signal))/Fs;
stem(t_sym(1:1000),baseband_signal(1:1000),"kx");hold on
plot(t_signal(1:1000),IF_signal(1:1000),"b-");hold off
title("数据脉冲成形效果")

end 
