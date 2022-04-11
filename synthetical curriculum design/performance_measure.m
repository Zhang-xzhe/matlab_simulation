%综合课程设计，3路SDR系统
%1、802.11b
%2、OFDM
%3、跳频系统

%系统参数设置（由于系统经过相同的信道，所以设为相同）
Fs = 40e6;                                                                 %采样率设为40MHz
IF_fre = 18e6;                                                             %扩频中频设为10MHz
IF_fre1 = 10e6;                                                            %OFDM中频设为15MHz
IF_fre2 = 2e6;                                                             %跳频中频设为2MHz

%按照802.11帧格式，形成发射的比特流
message = 'hello world';                                                   %发送的信息
frame = framer(message);                                                   %成PHY帧
dist_frame = disturber(frame);                                             %扰码
fram_length = length(dist_frame);                                          %帧长
for mode_num = 1:3
for i = 1:100
    SNR = -40+i; 
    %用户交互
    mode_request = "please choose a communication mode: 1.802.11b  2.OFDM 3.FHSS 4.quit\n ";
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 制式1——802.11b物理层           发射机
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %参数设置
    L = 10;                                                                    %扩频因子
    PN_code = [1,-1,1,1,-1,1,1,1,-1,-1];                                       %802.11定义的扩频码
    alpha_factor = 0.25;                                                       %升余弦滤波器滚降系数
    symbol_rate1 = 1e5;                                                         %数据率400kbits

    %差分编码
    diff_code = diff_coder(dist_frame);                                        %差分编码为后面IQ调制做准备
    %直接序列扩频
    DSSS_bits_I = DSSSer(diff_code(1,:),PN_code,L);                            %用PN码对其进行扩频,其中L为扩频因子
    DSSS_bits_Q = DSSSer(diff_code(2,:),PN_code,L);                            %用PN码对其进行扩频,其中L为扩频因子
    DSSS_bits = [DSSS_bits_I;DSSS_bits_Q];
    %脉冲成形
    shaped_signal_I = risecos(DSSS_bits_I,alpha_factor,Fs,symbol_rate1*L/2);    %防止码间干扰
    shaped_signal_Q = risecos(DSSS_bits_Q,alpha_factor,Fs,symbol_rate1*L/2);    %防止码间干扰
    shaped_signal = [shaped_signal_I;shaped_signal_Q];
    figure(912)
    plot(shaped_signal_Q(1:500))
    %DQPSK调制
    IF_signal1 = QPSKmodulator(shaped_signal,Fs,IF_fre);
    %功率归一
    IF_signal1 = IF_signal1./abs(IF_signal1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 制式2——OFDM
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %参数设置
    channel_num = 64;                                                          %10个子信道
    QAM_num = 16;                                                              %16QAM
    symbol_rate2 = 80e6;                                                      %数据率100kbits

    %串并转换
    multi_bits = uni_to_multi([dist_frame,dist_frame,dist_frame,dist_frame],channel_num);                %单转多
    %星座映射
    QAM_bits = QAM_map(multi_bits,channel_num);                                %映射为星座点
    %IFFT
    moudule_signal = OFDM(QAM_bits,channel_num);                               %调制
    %升采样
    ready_signal = up_inter(moudule_signal,symbol_rate2/QAM_num,Fs);
    %DA，IQ调制
    IF_signal2 = OFDM_IQ(ready_signal,IF_fre1,Fs);
    %功率归一
    IF_signal2 = IF_signal2./abs(IF_signal2);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 制式3——HFSS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %参数设置
    hop_fre = [0,5e5,10e5,15e5,20e5];                              %跳频频率
    BFSK_delta = 2e5;                                              %BFSK调制时差频500k
    hop_seq = hoplist(dist_frame);                                 %跳频序列产生
    hop_persymbol = 1;                                             %每个符号跳频的数目
    symbol_rate3 = 1e5;                                            %数据率100kbits

    %发送频率产生
    fre_seq = fre_generater(dist_frame,hop_fre,hop_seq,IF_fre2,BFSK_delta,hop_persymbol);     %频率计算
    %上变频发送
    IF_signal3 = FSK(Fs,symbol_rate3,fre_seq,hop_persymbol);                       %频移键控
    %功率归一
    IF_signal3 = IF_signal3./abs(IF_signal3);





     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                            信道
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




    IF_fre_channel = 10e6;                                                 %信道带宽
    passband_w = 18e6;                                                     %带通信道的带宽
    passband_filter_order = 46;                                            %带通信道阶数
    %信号合并（每通道信号循环发送）
    signal1_len = length(IF_signal1);
    signal2_len = length(IF_signal2);
    signal3_len = length(IF_signal3);
    signal_len = max([signal1_len,signal2_len,signal3_len]);
    IF_signal1_eq = IF_signal1;
    IF_signal2_eq = IF_signal2;
    IF_signal3_eq = IF_signal3;
    while(length(IF_signal1_eq)<signal_len)
        desire_len = signal_len-length(IF_signal1_eq);
        if desire_len<signal1_len
            IF_signal1_eq = [IF_signal1_eq,IF_signal1(1,desire_len)];
        else
            IF_signal1_eq = [IF_signal1_eq,IF_signal1];
        end
    end
    while(length(IF_signal2_eq)<signal_len)
        desire_len = signal_len-length(IF_signal2_eq);
        if desire_len<signal2_len
            IF_signal2_eq = [IF_signal2_eq,IF_signal2(1,desire_len)];
        else
            IF_signal2_eq = [IF_signal2_eq,IF_signal2];
        end
    end
    %对于跳频系统，还需扩展跳频序列
    hop_len = length(hop_seq);
    rate = signal3_len/hop_len;
    while(length(IF_signal3_eq)<signal_len)
        desire_len = signal_len-length(IF_signal3_eq);
        if desire_len<signal3_len
            IF_signal3_eq = [IF_signal3_eq,IF_signal3(1,desire_len)];
        else
            IF_signal3_eq = [IF_signal3_eq,IF_signal3];
        end
    end
    add_seq = length(IF_signal3_eq)/rate - length(hop_seq);
    hop_seq_eq = hop_seq;
    while(add_seq>0)
        if add_seq<hop_len
            hop_seq_eq = [hop_seq_eq,hop_seq(1:add_seq)];
            break
        else
            hop_seq_eq = [hop_seq_eq,hop_seq];
            add_seq = add_seq-hop_len;
        end
    end
%     %能量计算
%     energy1 = sum(IF_signal1_eq.^2);
%     energy2 = sum(IF_signal2_eq.^2);
%     energy3 = sum(IF_signal3_eq.^2);
%     %能量归一化
%     IF_signal1_eq = (IF_signal1_eq./energy1).*length(IF_signal1_eq);
%     IF_signal2_eq = (IF_signal2_eq./energy2).*length(IF_signal2_eq);
%     IF_signal3_eq = (IF_signal3_eq./energy3).*length(IF_signal3_eq);
    IF_signal = IF_signal1_eq+IF_signal2_eq+IF_signal3_eq;
    %噪声
    signal_energy = sum(IF_signal.^2)/length(IF_signal);                   %信号能量计算
    noise_strength = sqrt(signal_energy/(10.^(SNR/10)));                   %噪声强度
    %过信道
    receive_signal = channelpass(IF_signal,Fs,passband_filter_order,IF_fre_channel,passband_w,noise_strength);        %过带限信道




    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                            接收机
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch mode_num
        case 1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 制式1——802.11b物理层           接收机
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %参数设置
            L = 10;                                                                    %扩频因子
            PN_code = [1,-1,1,1,-1,1,1,1,-1,-1];                                       %802.11定义的扩频码
            alpha_factor = 0.25;                                                       %升余弦滤波器滚降系数
            bandW1 = symbol_rate1*L*2;
            
            %高通滤波器
            receive_signal1 = channel_choose1(receive_signal,Fs,IF_fre,bandW1);
            %IQ DQPSK解调
            demoduled_signal = de_DQPSK(receive_signal1,Fs,IF_fre,symbol_rate1*L);
            %抽样
            Dbits = sampler(demoduled_signal,Fs,symbol_rate1*L/2);
            %解扩
            deDSSS_signal = deDSSSer(Dbits,PN_code);
            %解差分
            bits = De_differ(deDSSS_signal);
            %解扰
            de_disturb_signal = de_disturber(bits);
            %读信息
            receiver_message = readframe(de_disturb_signal);
            error_num1(i) = sum(abs(de_disturb_signal(1:280)-double(frame)))/280;

 
        case 2
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 制式2——OFDM
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            %参数设置
            channel_num = 64;                                                          %10个子信道
            QAM_num = 16;                                                              %16QAM
            bandW2 = 0.2*symbol_rate2/QAM_num;

            %带通滤波器
            receive_signal2 = channel_choose2(receive_signal,Fs,IF_fre1,bandW2);
            %正交解调
            deIQ_signal = IQ_demodule(receive_signal2,Fs,IF_fre1);
            %降采样
            bits_stream = tran2bits(deIQ_signal,Fs,symbol_rate2/QAM_num);
            %FFT
            deOFDM_bits = de_OFDM(bits_stream(1:320),channel_num);
            %QAM解调
            deQAM_bits = de_QAM(deOFDM_bits,channel_num);
            %并串转换
            frame_bits = multi_to_uni(deQAM_bits,channel_num,fram_length);
            %解扰
            de_disturb_signal = de_disturber(frame_bits);
            %读信息
            receiver_message = readframe(de_disturb_signal);
            error_num2(i) = sum(abs(de_disturb_signal(1:280)-double(frame)))/280;

           
        case 3
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 制式3——HFSS
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %参数设置
            hop_fre = [0,5e5,10e5,15e5,20e5];                              %跳频频率
            BFSK_delta = 2e5;                                              %BFSK调制时其中一个频率
            bandW3 = 2*(max(hop_fre)+BFSK_delta+symbol_rate3/2);
            %低通滤波器
            receive_signal3 = channel_choose3(receive_signal,Fs,IF_fre2,bandW3);
            %解跳
            dehop_signal = dehop(receive_signal3,Fs,IF_fre2,BFSK_delta,hop_seq_eq,hop_fre,symbol_rate3);
            %BFSK解调
            deBFSK_signal = de_BFSK(dehop_signal,Fs,IF_fre2,BFSK_delta); 
            %抽样判决
            frame_bits = signal2bits(deBFSK_signal,symbol_rate3,Fs);
            %解扰
            de_disturb_signal = de_disturber(frame_bits);
            %读信息
            receiver_message = readframe(de_disturb_signal(1:280));
            display(receiver_message)
            error_num3(i) = sum(abs(de_disturb_signal(1:280)-double(frame)))/280;
        otherwise
            mode_error_message = "illegal choice, please input again";
            disp(mode_error_message);
            continue
    end
end
end

        plot([-49:50],log(error_num1),'b--',[-49:50],log(error_num2),'r--',[-49:50],log(error_num3),'y--')
        xlabel("SNR/dB")
        ylabel("误码率/dB")
        title("channel_performance")
        legend('DQPSK+扩频','16QAM+OFDM','BFSK+跳频')

% switch mode_num
%     case 1
%         plot([-49:50],log(error_num1))
%         xlabel("SNR/dB")
%         ylabel("误码率/dB")
%         title("channel1_performance")
%     case 2
%         plot([-49:50],log(error_num2))
%         xlabel("SNR/dB")
%         ylabel("误码率/dB")
%         title("channel2_performance")
%     case 3
%         plot([-49:50],log(error_num3))
%         xlabel("SNR/dB")
%         ylabel("误码率/dB")
%         title("channel3_performance")
% end