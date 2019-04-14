close all
clear all
clc

%% Hello World LMI
%dx = A(alpha)x
A=rand(3)-1*eye(3); %sistema

%% define variaveis
P=sdpvar(3,3,'symmetric');

%% define LMIs
lmis=[P>=0 (A'*P+P*A<=0)];

%% busca solucao
sol=solvesdp(lmis,[])

%% testa solucao (forma 1)
P=double(P)
LMI=A'*P+P*A

if (min(real(eig(P)))>0 && max(real(eig(LMI)))<0)
   disp('Sistema estável')
else
   disp('Sistema instável')
end

%% testa solucao (forma 2)
r=min(checkset(lmis))
if r>0
   disp('Sistema estável')
else
   disp('Sistema instável')
end