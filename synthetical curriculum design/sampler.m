function bits = sampler(matched_signal,Fs,symbol_rate)
%计算每个符号的采样点
sample_persym = Fs/symbol_rate;    
%计算每路信号将有多少个采样点
all_sample_num = floor(length(matched_signal(1,:))/sample_persym);
%为采样后的数据分配空间
bits = zeros(2,all_sample_num);                                            
for i = 1:all_sample_num
    if matched_signal(1,i*sample_persym-sample_persym/2) >0
        bits(1,i) = 1;
    else
        bits(1,i) = -1;
    end
    if matched_signal(2,i*sample_persym-sample_persym/2) >0
        bits(2,i) = 1;
    else
        bits(2,i) = -1;
    end
end
end


