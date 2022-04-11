function deQAM_bits = de_QAM(deOFDM_bits,channel_num)

deQAM_bits = zeros(channel_num,length(deOFDM_bits(1,:))*4);

point_vector = [-2+2i,-1+2i,1+2i,2+2i,-2+1i,-1+1i,1+1i,2+1i,-2-1i,-1-1i,1-1i,2-1i,-2-2i,-1-2i,1-2i,2-2i];

for k = 1:channel_num
    for j = 1:length(deOFDM_bits(1,:))
        symbol = deOFDM_bits(k,j)*ones(1,16);
        distant = abs(symbol-point_vector);
        [minimum,position] = min(distant);
        position = position - 1;
        bits = de2bi(position,4,"right-msb");
        deQAM_bits(k,(j-1)*4+1:j*4) = bits;
    end
end
       

end