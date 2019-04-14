function plotPole(p)
for j=1:length(p)
    if (real(p(j))<0)
        plot(real(p(j)),imag(p(j)),'*g')
    else
        plot(real(p(j)),imag(p(j)),'*r')
    end
    hold on
end
end