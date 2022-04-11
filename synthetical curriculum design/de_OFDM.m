function deOFDM_bits = de_OFDM(deIQ_signal,channel_num)

deOFDM_bits = zeros(channel_num,floor(length(deIQ_signal)/channel_num));

for i = 1:channel_num:length(deIQ_signal)
    deOFDM_bits(:,(i-1)/channel_num+1) = fft(deIQ_signal(i:i+channel_num-1));
end


end
