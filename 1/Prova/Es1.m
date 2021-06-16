% Esercitazione 1
% ma = somm(F)
%    = Fk - Fb
% Fk = -kx
% Fb = bx'
% F = mx''
% x' = v
% mv' = kx - bv
% Uso la rappresentazione nello spazio degli stati nel caso in cui il
% sistema sia nonlineare e non sia possibile applicare la trasformata di
% Laplace per analizzarlo

% x' = Ax + Bu
% y = Cx + Du

% x1 = posiz, x2 = veloc
%  | x1' = x2
%  | x2' = (-k/m)x1 - (b/m)x2 + (F/m)

clear all

k=0.25;
m=1;
b=1;
F=1;
x0 = [1 1];
A = [0 1; -k/m -b/m];
B = [0 F/m]'; % vettore colonna nel caso di sistemi SISO
C = [1 0]; % vettore riga

% x' = 0 per trovare il punto di equilibrio del sistema
xeq=[0.25;0];
