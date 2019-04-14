close all
clear all
clc

%% Realimentação Robusta
N=3; %vertices
n=2; %estados
m=1; %entradas

%% Vertices
a=1.2;
A={randn(n)-a*eye(n),randn(n)-a*eye(n),randn(n)-a*eye(n)};
B={randn(n,m),randn(n,m),randn(n,m)};
%% Testa Estabilidade via Forca Bruta
for i=1:100
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
pause
%% Projeta Controlador
%% Variáveis
W=sdpvar(n,n,'symmetric');
Z=sdpvar(m,n,'full');
%% Lmis
lmis=[W>=0];
for i=1:N
   lmis=[lmis (W*A{i}'+A{i}*W+Z'*B{i}'+B{i}*Z<=0)];
end
%% Busca Solucao
sol=solvesdp(lmis,[])
%% Testa Solucao
r=min(checkset(lmis));
if r>0
    disp('Politopo é estabilizavel')
 K=double(Z)*inv(double(W))
pause
%% Forca Bruta
for i=1:100
    a=rand(N,1); %sorteia parâmetros
    a=a/sum(a); %garante que somatoria da 1
    %% grid
    figure(2)
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
    Bt=a(1)*B{1}+a(2)*B{2}+a(3)*B{3};
    sys=ss(At+Bt*K,Bt,eye(n),zeros(n,m));
    p=eig(At+Bt*K);
    subplot(2,1,1)
    if (max(real(p))<0)
        plot(real(p),imag(p),'*g')
    else
        plot(real(p),imag(p),'*r')
    end
    
    subplot(2,1,2)
    title(['Resposta Temporal (' num2str(i) ')'])
    y=impulse(sys);
    plot(y,'b')
    pause(0.001)
end
else
    disp('LMI infactivel')
end