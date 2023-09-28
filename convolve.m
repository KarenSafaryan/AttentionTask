input = rand(100,1); %generate random input
kernal = exp(linspace(-1,-10,10))'./sum(exp(linspace(-1,-10,10))); %normalized kernal
m = length(kernal);n = length(input); %length vars
out = zeros(m+n-1,1); %output placeholder

for i = 1:m+n-1 %for values
    for j = max(1,(i-(m-1))):min(n,i) %for window
        out(i)=out(i)+input(j)*kernal(i-j+1); %sum convolution product 
    end
end

%F(f(x)Xg(x)) = F(f(x))F(g(x))
%so: F^-1(F(f(x))F(g(x))) == f(x)Xg(x)
newkernal = [kernal' zeros(1,90)]'; %pad with zeros
out2 = ifft(fft(input).*fft(newkernal));

figure
subplot(1,3,1)
stem(out)
title('Manual Convolution')
xlim([0 110])
subplot(1,3,2)
stem(conv(input,kernal))
title('Matlab Conv()')
xlim([0 110])
subplot(1,3,3)
stem(out2)
title('Convolution Theorem Result')
xlim([0 110])
