close all
clear all
clc

%% exp1 - Modelo Pendulo Invertido

m = 0.5; %massa da haste
l = 1; %comprimento da haste
I = m*l^2/12; %inercia da haste
b = 0.1; %coef. de atrito do carrinho
M = 1.5; %massa do carrinho
g = 9.8; %aceleracao da gravidade

k = I*(M+m)+M*m*l^2;
A0 = [0      1              0           0;
    0 -(I+m*l^2)*b/k  (m^2*g*l^2)/k   0;
    0      0              0           1;
    0 -(m*l*b)/k       m*g*l*(M+m)/k  0];
B0 = [     0;
    (I+m*l^2)/k;
    0;
    m*l/k];
p_ma=eig(A0)
sys=ss(A0,B0,eye(4),0); %dx=Ax+Bu // y=x
figure(1)
subplot(1,2,1)
for j=1:length(p_ma)
    if (real(p_ma(j))<0)
        plot(real(p_ma(j)),imag(p_ma(j)),'*g')
    else
        plot(real(p_ma(j)),imag(p_ma(j)),'*r')
    end
    hold on
end
subplot(1,2,2)
[y,t]=impulse(sys);
plot(t,y,'b')
title('Estados')
suptitle('Malha Aberta')
%% State-Feedback Controller
K=place(A0,B0,[-0.3140;-0.3025;-0.3200;-0.3210]);
p_mf=eig(A0-B0*K)

%% Robustness Test
for m=0.5:0.01:0.6
    k = I*(M+m)+M*m*l^2; 
    A = [0      1              0           0;
        0 -(I+m*l^2)*b/k  (m^2*g*l^2)/k   0;
        0      0              0           1;
        0 -(m*l*b)/k       m*g*l*(M+m)/k  0];
    B = [0; (I+m*l^2)/k;  0;     m*l/k];
    p_mf=eig(A-B*K);
    figure(2)
    subplot(1,2,1)
    hold on
  for j=1:length(p_mf)
    if (real(p_mf(j))<0)
        plot(real(p_mf(j)),imag(p_mf(j)),'*g')
    else
        plot(real(p_mf(j)),imag(p_mf(j)),'*r')
    end
    hold on
end
    grid on
    hold off
    subplot(1,2,2)
    sys=ss(A-B*K,ones(4,1),eye(4),0); %dx=(A-BK)x // y=x
    [y,t]=impulse(sys);
    plot(t,y,'b')
     title(['m=' num2str(m)])
    hold on
    grid on
    pause
end

%%
