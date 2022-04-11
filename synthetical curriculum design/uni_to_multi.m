function multi_bits = uni_to_multi(dist_frame,channel_num)

length_perchannel = ceil(length(dist_frame)/channel_num);

for i = 1:length_perchannel
    for j = 1:channel_num
        if (i-1)*channel_num +j > length(dist_frame)
            multi_bits(j,i) = 0;
        else
            multi_bits(j,i) = dist_frame((i-1)*channel_num +j);
        end
    end
end