function IF_signal = QPSKmodulator(shaped_signal,Fs,IF_fre)
%载波信号时间轴
t = 1:length(shaped_signal(1,:));
t = t/Fs;
%产生载波信号
I_cos = cos(2*pi*IF_fre.*t);
Q_sin = cos(2*pi*IF_fre.*t-pi/2);
%上变频
I_moduled = shaped_signal(1,:).*I_cos;
Q_moduled = shaped_signal(2,:).*Q_sin;
%IQ信号求和
IF_signal = (I_moduled+Q_moduled);
end