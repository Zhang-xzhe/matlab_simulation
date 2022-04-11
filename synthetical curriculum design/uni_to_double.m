function s = uni_to_double(x)

for i = 1:length(x)
    if x(i) == 0
        x(i) = -1;
    end
    s = x;
end