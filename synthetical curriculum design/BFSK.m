function BFSK_signal = BFSK(dist_frame,symbol_rate,IF_fre,BFSK_delta,Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             说明
%                  通过dis_frame的值键控输出频率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%计算每个符号的采样点数
sample_persym = Fs/symbol_rate;
t = 1:sample_persym;
t = t/Fs;
BFSK_f1 = cos(2*pi*IF_fre*t);
BFSK_f2 = cos(2*pi*(IF_fre+BFSK_delta)*t);

BFSK_signal = zeros(1,length(dist_frame)*sample_persym);
for i = 1:length(dist_frame)
    if dist_frame(i) == 1
        BFSK_signal((i-1)*sample_persym+1:i*sample_persym) = BFSK_f1;
    else
        BFSK_signal((i-1)*sample_persym+1:i*sample_persym) = BFSK_f2;
    end
end

end
