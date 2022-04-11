function QAM_bits = QAM_map(multi_bits,channel_num)

for i = 1:4
    if mod(length(multi_bits(1,:)),4) ~= 0
        multi_bits = [multi_bits,zeros(channel_num,1)];
    end
end

QAM_bits = zeros(channel_num,length(multi_bits(1,:))/4);

for k = 1:channel_num
    for j = 1:4:length(multi_bits(1,:))
        switch bi2de(multi_bits(k,j:j+3))
            case 0
                QAM_bits(k,(j+3)/4) = -3+3i;
            case 1
                QAM_bits(k,(j+3)/4) = -1+3i;
            case 2
                QAM_bits(k,(j+3)/4) = 1+3i;
            case 3
                QAM_bits(k,(j+3)/4) = 3+3i;
            case 4
                QAM_bits(k,(j+3)/4) = -3+1i;
            case 5
                QAM_bits(k,(j+3)/4) = -1+1i;
            case 6
                QAM_bits(k,(j+3)/4) = 1+1i;
            case 7
                QAM_bits(k,(j+3)/4) = 3+1i;
            case 8
                QAM_bits(k,(j+3)/4) = -3-1i;
            case 9
                QAM_bits(k,(j+3)/4) = -1-1i;
            case 10
                QAM_bits(k,(j+3)/4) = 1-1i;
            case 11
                QAM_bits(k,(j+3)/4) = 3-1i;
            case 12
                QAM_bits(k,(j+3)/4) = -3-3i;
            case 13
                QAM_bits(k,(j+3)/4) = -1-3i;
            case 14
                QAM_bits(k,(j+3)/4) = 1-3i;
            case 15
                QAM_bits(k,(j+3)/4) = 3-3i;
        end
    end
end

end