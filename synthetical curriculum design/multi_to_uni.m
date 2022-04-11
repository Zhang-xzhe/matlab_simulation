function fram_bits = multi_to_uni(deQAM_bits,channel_num,fram_length)

bits = zeros(1,channel_num*length(deQAM_bits(1,:)));

for k = 1:length(deQAM_bits(1,:))
    for j = 1:channel_num
        bits(channel_num*(k-1)+j) = deQAM_bits(j,k);
    end
end

fram_bits = bits(1:fram_length);

end