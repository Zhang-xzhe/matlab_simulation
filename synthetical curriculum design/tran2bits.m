function bits_stream = tran2bits(deIQ_signal,Fs,symbol_rate)
%抽取系数
decimate_factor = Fs/symbol_rate;
%抽取后长度
bits_length = length(deIQ_signal)/decimate_factor;
%为bit流预分配空间
bits_stream = zeros(1,bits_length);

for i = decimate_factor:decimate_factor:length(deIQ_signal)

    bits_stream(i/decimate_factor) = deIQ_signal(i);

end


end