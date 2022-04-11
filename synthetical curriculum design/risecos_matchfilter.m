function filtered_signal = risecos_matchfilter(receive_signal,alpha_factor,Fs,symbol_rate)

rcos_filter = rcosdesign(alpha_factor,6,Fs/symbol_rate,"sqrt");
figure(5)
plot(rcos_filter)
figure(6)
plot(cconv(rcos_filter,1,rcos_filter))
filtered_signal_I = cconv(rcos_filter,1,receive_signal(1,:));
filtered_signal_Q = cconv(rcos_filter,1,receive_signal(2,:));
filtered_signal = [filtered_signal_I;filtered_signal_Q];
end