close all
clear all
clc

%% Realimentação Robusta
N=3; %vertices
n=2; %estados
m=1; %entradas
py=n; %saidas

%% Vertices
a=2.92;
A={randn(n)-a*eye(n),randn(n)-a*eye(n),randn(n)-a*eye(n)};
B0=randn(n,m);
Bu={B0,B0,B0};
Bw={B0,B0,B0};
C0=randn(py,n);
C={C0,C0,C0};
Du0=zeros(py,m);
Du={Du0,Du0,Du0};
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
%% Projeta Controlador Robusto H2
%% Variáveis
W=sdpvar(n,n,'symmetric');
X=sdpvar(py,py,'symmetric');
Z=sdpvar(m,n,'full');
%% Lmis
lmis=[W>=0];
for i=1:N
    LMI1 = [X C{i}*W+Du{i}*Z;...
            W*C{i}'+Z'*Du{i}' W];
    LMI2 = [W*A{i}'+A{i}*W+Z'*Bu{i}'+Bu{i}*Z Bw{i};...
            Bw{i}' -eye(m)];
   lmis=[lmis LMI1>=0 LMI2<=0];
end
%% Busca Solucao
sol=solvesdp(lmis,trace(X))
%% Testa Solucao
r=min(checkset(lmis));
if (r>0||abs(r)<1e-7)&&(sol.problem==0)
    disp('Politopo é estabilizavel')
 K=double(Z)*inv(double(W))
 normaH2=sqrt(trace(double(X)))
pause
 hnorm2=[];
%% Forca Bruta
for i=1:100
    a=rand(N,1); %sorteia parâmetros
    a=a/sum(a); %garante que somatoria da 1
    %% grid
    figure(2)
    subplot(3,1,1)
    grid on
    hold on
    xlabel('Real')
    ylabel('Imag')
    title('Plano-s')
    subplot(3,1,2)
    grid on
    hold on
    xlabel('\alpha')
    title('Parâmetros')
    subplot(3,1,3)
    grid on
    hold on
    title('Norma H2')
  
    At=a(1)*A{1}+a(2)*A{2}+a(3)*A{3};
    But=a(1)*Bu{1}+a(2)*Bu{2}+a(3)*Bu{3};
    Bwt=a(1)*Bw{1}+a(2)*Bw{2}+a(3)*Bw{3};
    Ct=a(1)*C{1}+a(2)*C{2}+a(3)*C{3};
    Dut=a(1)*Du{1}+a(2)*Du{2}+a(3)*Du{3};
    sys=ss(At+But*K,Bwt,Ct+Dut*K,zeros(py,m));
    
    p=eig(At+But*K);
    subplot(3,1,1)
    if (max(real(p))<0)
        plot(real(p),imag(p),'*g')
    else
        plot(real(p),imag(p),'*r')
    end
    
    subplot(3,1,2)
    title(['Resposta Temporal (' num2str(i) ')'])
    y=impulse(sys);
    plot(y,'b')
    
    subplot(3,1,3)
    hold off
    hnorm2=[hnorm2 norm(sys,2)];
    plot(hnorm2,'*g')
    hold on
    line([0 length(hnorm2)],[normaH2 normaH2],'color','black','linestyle','--','linewidth',2)
    title('Norma H2')
    pause(0.001)
end
else
    disp('LMI infactivel')
end