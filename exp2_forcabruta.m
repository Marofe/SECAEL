clear all
clc

%% forca bruta
n=4; %numero de estados
N=3; %numero de sistemas
for j=1:N
    close all
    disp(['sistema=' num2str(j)])
    %vertices
    if (j==N)
        %sorteia um sisitema possivelmente estável
        A1=randn(n)-5*eye(n);
        A2=randn(n)-5*eye(n);
    else
        %sorteia sistemas possivelmente instáveis
        A1=randn(n)-eye(n);
        A2=randn(n)-eye(n);
    end
    
    %% grid
    figure(1)
    subplot(2,1,1)
    grid on
    hold on
    xlabel('Real')
    ylabel('Imag')
    title('Plano-s')
    subplot(2,1,2)
    grid on
    hold on
    xlabel('\alpha')
    axis([0 1 -0.1 0.1])
    for a=0:0.01:1
        A=a*A1+(1-a)*A2;
        p=eig(A);
        subplot(2,1,1)
        if (max(real(p))<0)
            plot(real(p),imag(p),'*g')
        else
            plot(real(p),imag(p),'*r')
        end
        
        subplot(2,1,2)
        title(['Parâmetro (\alpha=' num2str(a) ')'])
        plot(a,0,'*b')
        if (a==0 && j==1)
            pause
        else
            pause(0.01)
        end
    end
    if (j<N) 
        pause
    end
end
