function receiver_message = readframe(bits)
PHY1 = bits(1:128);
PHY2 = bits(129:144);
PHY3 = bits(145:152);
PHY4 = bits(153:160);
PHY5 = bits(161:176);
PHY6 = bits(177:192);
for i = 1:8
    if mod(length(bits)-192,8) ~= 0
        bits = [bits,0];
    end
end
mac_bits = bits(193:length(bits));
bi_message = reshape(mac_bits,[],8);
de_message = bi2de(bi_message);
receiver_message = char(de_message);
end