function bits = De_differ(Dbits)


% data = zeros(1,144);
% 
% for i = 2:145
%     if Dbits(:,i).*Dbits(:,i-1) > 1
%         data(i-1) = 0;
%     else
%         data(i-1) = 1;
%     end
% end

data = [];
%构造反旋转矩阵
A = [0,1;-1,0];                                                             %90°旋转矩阵
B = [-1,0;0,-1];                                                           %180°旋转矩阵
C = [0,-1;1,0];                                                            %-90°旋转矩阵
for i = 2:length(Dbits(1,:))
    a = A*Dbits(:,i-1);
    b = B*Dbits(:,i-1);
    c = C*Dbits(:,i-1);
    switch bi2de((Dbits(:,i)+[1;1])'./2,'left-msb')
        case bi2de((a+[1;1])'./2,'left-msb')
            data = [data,0,1];
        case bi2de((b+[1;1])'./2,'left-msb')
            data = [data,1,1];
        case bi2de((c+[1;1])'./2,'left-msb')
            data = [data,1,0];
        otherwise
            data = [data,0,0];
    end
end
bits = data;
end