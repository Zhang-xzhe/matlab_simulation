function deDSSS_signal = deDSSSer(matched_signal,PN_code)

% sample_persym = Fs/symbol_rate;                                              
% 
% deDSSS_signal = zeros(1,length(PN_code)*sample_persym);
% for i = 1:length(PN_code)
%     if PN_code(i) == 1
%         new = ones(1,sample_persym);
%     else
%         new = -ones(1,sample_persym);
%     end
%     deDSSS_signal((i-1)*sample_persym + 1:i*sample_persym) = new;
% end

%产生解扩序列
PN_code_new = [];
for k = 1:floor(length(matched_signal)/length(PN_code))
    PN_code_new = [PN_code_new,PN_code];
end
%解扩
deDSSS_signal_I = PN_code_new.*matched_signal(1,:);
deDSSS_signal_Q = PN_code_new.*matched_signal(2,:);
deDSSS_signal = zeros(2,length(deDSSS_signal_Q)/10);
%合并相同的码字
for i = 10:10:length(deDSSS_signal_I)
    if sum(deDSSS_signal_I(i-9:i))/10 > 0
        deDSSS_signal(1,i/10) = 1;
    else
        deDSSS_signal(1,i/10) = -1;
    end
    if sum(deDSSS_signal_Q(i-9:i))/10 > 0
        deDSSS_signal(2,i/10) = 1;
    else
        deDSSS_signal(2,i/10) = -1;
    end
end


% temp = deDSSS_signal;
% 
% for i = 1:floor(length(matched_signal(1,:))/length(deDSSS_signal))-1
%     deDSSS_signal = [deDSSS_signal,temp];
% end
% 
% deDSSS_signal = [deDSSS_signal,zeros(1,length(matched_signal(1,:))-length(deDSSS_signal))];
% 
% deDSSS_signal_I = deDSSS_signal.*matched_signal(1,:);
% deDSSS_signal_Q = deDSSS_signal.*matched_signal(2,:);
% 
% deDSSS_signal = [deDSSS_signal_I;deDSSS_signal_Q];
end