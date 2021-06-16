clear all
%e1=40;
%e2=20;
%e=0.2;
%p=0.3;
%K1=150;

% e1=40;
% e2=10;
% e=0.1;
% p=0.2;
% K1=800;

% e1=40;
% e2=10;
% e=0.1;
% p=0.2;
% K1=4000;
% d1=15;
% d2=0;



x0=[10;25];

xeq1=[0;0]
xeq2=[e2/(e*p) e1/p-e1*e2/(e*K1*p^2)]
xeq3=[K1;0]

[A1,B1,C1,D1]=linmod('es4_sim_nograf',xeq1);
eig(A1)
[A2,B2,C2,D2]=linmod('es4_sim_nograf',xeq2);
eig(A2)
[A3,B3,C3,D3]=linmod('es4_sim_nograf',xeq3);
eig(A3)