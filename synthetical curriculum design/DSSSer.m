function DSSS_bits = DSSSer(double_polar_signal,PN_code,L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                说明
%               输入分别是基带信号，扩频码，扩频因子
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
new_signal = [];
for i = 1:length(double_polar_signal)
    for j = 1:L
        new_signal = [new_signal,double_polar_signal(i)];
    end
end

PN_code_new = [];
for k = 1:floor(length(new_signal)/length(PN_code))
    PN_code_new = [PN_code_new,PN_code];
end

DSSS_bits = new_signal.*PN_code_new;

end