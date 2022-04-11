function IF_signal = FSK(Fs,symbol_rate,fre_seq,hop_persymbol)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               连续相位调制
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算时间轴
sample_num = Fs*length(fre_seq)*hop_persymbol/symbol_rate;
t = 1:sample_num;
t = t/Fs;
%计算相位
sample_perhop = Fs/(symbol_rate*hop_persymbol);
phase = zeros(1,sample_num); 
for i = 2:sample_num
    phase(i) = phase(i-1)+2*pi*(1/Fs)*fre_seq(ceil(i/sample_perhop));
end
%生成发射信号
IF_signal = cos(phase);


% %计算每个符号的采样点数
% sample_persym = Fs/symbol_rate;
% t = 1:sample_persym/hop_persymbol;
% t = t/Fs;
% 
% IF_signal = zeros(1,length(fre_seq)*sample_persym/hop_persymbol);
% 
% for i = 1:length(fre_seq)
%     IF_signal((i-1)*sample_persym/hop_persymbol+1:i*sample_persym/hop_persymbol) = cos(2*pi*fre_seq(i)*t);
% end


end