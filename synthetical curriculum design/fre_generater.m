function fre_seq = fre_generater(dist_frame,hop_fre,hop_seq,IF_fre,BFSK_delta,hop_persymbol)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            说明
%                   本模块计算信号的频率变化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fre_seq = zeros(1,length(dist_frame)*hop_persymbol);                       %频率变化的长度等于每个符号的跳数乘总符号数

for i = 1:length(dist_frame)
    for j = 1:hop_persymbol
        fre_seq((i-1)*j+j) =  fre_seq(i+j-1)+hop_fre(hop_seq((i-1)*j+j))+dist_frame(i)*BFSK_delta+IF_fre;
    end
end

end