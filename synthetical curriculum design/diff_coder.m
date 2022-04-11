function diff_code = diff_coder(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            说明
% 本模块将帧用DQPSK，进行差分编码，极性转换和串并转换
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diff_code = [1;1];                                                         %信号初始相位为pi/4


%旋转矩阵
A = [0,1;-1,0];                                                             %90°旋转矩阵
B = [-1,0;0,-1];                                                           %180°旋转矩阵
C = [0,-1;1,0];                                                            %-90°旋转矩阵

for i = 2:2:length(x)
    switch bi2de(x(i-1:i),'left-msb')
        case 0 %00
            new_code = diff_code(:,(i)/2);
        case 1 %01
            new_code = A*diff_code(:,(i)/2);
        case 2 %10
            new_code = C*diff_code(:,(i)/2);
        case 3 %11
            new_code = B*diff_code(:,(i)/2);
    end
    diff_code = [diff_code,new_code];
end
            
