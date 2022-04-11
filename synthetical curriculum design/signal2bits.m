function frame_bits = signal2bits(deBFSK_signal,symbol_rate,Fs)

%参数计算
samples_persym = Fs/symbol_rate;                                           %每个符号的采样数
enegry = mean(abs(deBFSK_signal))
%为抽样后的bit流预分配空间
frame_bits = zeros(1,floor(length(deBFSK_signal)/samples_persym));

for i = 1:samples_persym:length(deBFSK_signal)-samples_persym
    if deBFSK_signal(i+floor(samples_persym/2)) > enegry
        frame_bits((i-1)/samples_persym+1) = 0;
    else
        frame_bits((i-1)/samples_persym+1) = 1;
    end
end



end