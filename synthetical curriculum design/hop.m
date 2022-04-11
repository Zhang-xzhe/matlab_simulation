function IF_signal = hop(BFSK_signal,Fs,IF_fre,hop_seq,hop_fre,symbol_rate)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              说明
%                        根据跳频序列跳频
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%计算每个符号的采样点数
sample_persym = Fs/symbol_rate;
t = 1:sample_persym;
t = t/Fs;
symbol_num = floor(length(BFSK_signal)/sample_persym);
%跳频信号矩阵
hop_signal = zeros(length(hop_fre),sample_persym);
for i = 1:length(hop_fre)
    hop_signal(i,:) = cos(2*pi*hop_fre(i)*t);
end

IF_signal = zeros(1,length(BFSK_signal));

LPF = fir1(46,2*(IF_fre)/Fs);

for i = 1:symbol_num
    switch hop_seq(i)
        case 1
            new_signal = hop_signal(1,:);
        case 2
            new_signal = hop_signal(2,:);
        case 3
            new_signal = hop_signal(3,:);
        case 4
            new_signal = hop_signal(4,:);
        otherwise
            new_signal = hop_signal(5,:);
    end
    IF_signal((i-1)*sample_persym+1:i*sample_persym) = BFSK_signal((i-1)*sample_persym+1:i*sample_persym).*new_signal;
    IF_signal((i-1)*sample_persym+1:i*sample_persym) = filtfilt(LPF,1,IF_signal((i-1)*sample_persym+1:i*sample_persym));
end