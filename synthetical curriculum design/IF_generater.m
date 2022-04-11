function module_signal = IF_generater(DSSS_bits,IF_fre,Fs,symbol_rate,L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             说明
% 本模块输入为串行比特流，载波频率，采样频率，比特流速率
%       输出为DQPSK后的中频信号
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%参数计算
cycle_persym = IF_fre/symbol_rate;                                         %求每个基带符号对应载波的周期数
phase = cycle_persym*2*pi;                                                 %一个符号对应的相位变化
phase_diff_persym = mod(phase,2*pi);                                       %一个符号初相的变化
T = 1/symbol_rate;                                                         %符号周期
sample_num = T*Fs;                                                         %采样点数
t = 1:sample_num;
t = t*T/sample_num;                                                        %一个符号周期的采样时间
signal_part1 = cos(2*pi*IF_fre*t);                                         %做一个符号内的载波
temp_phase = 0;                                                            %每个符号结束时的相位
module_signal = signal_part1;                                              %第一个空码元


%根据协议码元前144位均为DBPSK，所以先进行BPSK

for i = 1:144*L
    if DSSS_bits(i) == -1
        temp_phase = temp_phase + phase_diff_persym;                       %如果为1相位不偏转，正常时延
    else
        temp_phase = temp_phase + phase_diff_persym+pi;
    end
    signal_part2 = cos(2*pi*IF_fre*t+temp_phase);                      %生成当前符号的调制信号
    module_signal = [module_signal,signal_part2];
end

%后面的码元采用DQPSK

for i = 144*L+2:2:length(DSSS_bits)
    %a = (DSSS_bits(i-1:i-1)+1)./2
    switch bi2de((DSSS_bits(i-1:i)+1)./2)
        case 0
            temp_phase = temp_phase + phase_diff_persym;
        case 1
            temp_phase = temp_phase + phase_diff_persym+pi/2;
        case 2
            temp_phase = temp_phase + phase_diff_persym+pi;
        case 3
            temp_phase = temp_phase + phase_diff_persym+3*pi/2;
    end
    signal_part2 = cos(2*pi*IF_fre*t+temp_phase);                      %生成当前符号的调制信号
    module_signal = [module_signal,signal_part2];
    
end
