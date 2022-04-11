function verify_code = RCRcheck(data,key)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%说明
%传入的是两个二进制数组，返回二进制数组
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

datalength = length(data);
data1 = bi2de(data,'left-msb');

keylength = length(key);
key1 = bi2de(key,'left-msb');

key1 = bitshift(uint64(key1),datalength-keylength);                        %先移到跟data一样长
data1 = bitshift(uint64(data1),keylength-1);                               %左移16位
key1 = bitshift(uint64(key1),keylength-1);                                 %左移16位

for k = 1:datalength
    if bitget(data1,datalength+keylength-1)
        data1 = bitxor(data1,key1);
    end
    data1 = bitshift(data1,1);
end

check_re = bitshift(data1,-datalength);
verify_code = de2bi(check_re,16,'left-msb');

end