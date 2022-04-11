function s = framer(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%说明
%本编码采用ASCII编码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
de_message = abs(x);                                                       %将字符转为其ASCII码
bi_message = de2bi(de_message,8);                                          %将十进制ASCII码转为二进制
mac_bits = reshape(bi_message,1,numel(bi_message));                                          %将二进制矩阵转为bit流
PHY1 = ones(1,128);                                                        %同步 使锁相环锁上
PHY2 = [1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0];                                  %识别字 开始帧界定符
PHY3 = [0,0,0,1,0,1,0,0];                                                  %信号 决定后面的调制方式，这里选择用DQPSK
PHY4 = zeros(1,8);                                                         %服务 保留字段
PHY5 = de2bi(length(mac_bits),16);                                         %长度字段
PHY6 = RCRcheck([PHY3,PHY4,PHY5],[1,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,1]);     %生成CRC校验字段
s = [PHY1,PHY2,PHY3,PHY4,PHY5,PHY6,mac_bits];
end