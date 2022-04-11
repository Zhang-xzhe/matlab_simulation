function result = receiver_CRCcheck(data,key)

datalength = length(data);
keylength = length(key);

data1 = bi2de(data,'left-msb');
key1 = bi2de(key,'left-msb');

key1 = bitshift(key1,datalength-keylength);

for i = 1:datalength-keylength+1
    if bitget(data1,datalength)
        data1 = bitxor(data1,key1);
    end
        data1 = bitshift(data1,1);
end
if data1 == 0
    result = 1;
else
    result = 0;
end
end