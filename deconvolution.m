% Devoncolution operation

u =[2 7 4 9]
v = [1 0 1]

[q, r] = deconv(u, v)

%% Convolution

k = conv(v, q) + r

if (u == k)
    fprintf("they are same")
else
    fprintf("different")
end