close all
clear all
clc

%% Estabilidade Quadrática
N=3; %vertices
n=2; %estados

%% Vertices
a=1.2;
A={randn(n)-a*eye(n),randn(n)-a*eye(n),randn(n)-a*eye(n)};
%% Variáveis
P=sdpvar(n,n,'symmetric');
%% Lmis
lmis=[P>=0];
for i=1:N
    lmis=[lmis (A{i}'*P+P*A{i}<=0)];
end
%% Busca Solucao
sol=solvesdp(lmis,[])
%% Testa Solucao
r=min(checkset(lmis));
if r>0
    disp('Politopo estável')
else
    disp('LMI infactivel')
end
pause
%% Forca Bruta
for i=1:200
    a=rand(N,1); %sorteia parâmetros
    a=a/sum(a); %garante que somatoria da 1
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
    title('Parâmetros')
    At=a(1)*A{1}+a(2)*A{2}+a(3)*A{3};
    p=eig(At);
    subplot(2,1,1)
    if (max(real(p))<0)
        plot(real(p),imag(p),'*g')
    else
        plot(real(p),imag(p),'*r')
    end
    
    subplot(2,1,2)
    title(['Parâmetros (' num2str(i) ')'])
    plot3(a(1),a(2),a(3),'*b')
    pause(0.001)
end