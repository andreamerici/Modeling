 %% equazione differenziale s.l.

% m*xdd+b*xd+k*x=u    xdd= accelerazione xd= velocita x=posizione

% m*xdd= u-b*xd-k*x
% xdd= -b/m*xd - k/m*x +u/m

% SPAZIO DEGLI STATI
% xd=A*x+B*u
% y=C*x+D*u

% x1= posizione
% x1d= velocita
% x2= velocita
% x2d= accelerazione

% x1d= x2;
% x2d= -b/m*x2 - k/m*x1 +u/m

close all; clear all; clc;


k=0.25;
m=1;
b=1;
u=1;

A=[0 1;
    -k/m -b/m];
B=[0 1/m]';
C=[1 0];
D=0;

x0=[1;1];
xeq=-inv(A)*B*u
tmax=50;

[t,x,out]=sim('Es1_sim.mdl');
y=out;

figure
plot(t,x(:,1))

figure
plot(t,x(:,2))

figure
plot(x(:,1),x(:,2))

figure
plot(t,y)

% %% simulazione sistemi lineari con lsim
% 
% t=0:0.01:50;
% 
% u(1:length(t))=u;
% 
% sys=ss(A,B,C,D);
% 
% [y,t,x]=lsim(sys,u,t,x0)
% 
% figure
% plot(t,y)