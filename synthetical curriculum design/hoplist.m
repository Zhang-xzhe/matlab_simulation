function hop_seq = hoplist(dist_frame)

symbol_num = length(dist_frame);
hop_seq = randi(5,1,symbol_num);

end