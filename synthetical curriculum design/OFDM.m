function moudule_signal = OFDM(QAM_bits,channel_num)

moudule_signal = zeros(1,channel_num*length(QAM_bits(1,:)));

for i = 1:length(QAM_bits(1,:))
    moudule_signal((i-1)*channel_num+1:i*channel_num) = ifft(QAM_bits(:,i));
end


end
