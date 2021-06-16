clear all

xeq1=[0;0];
xeq2=[2;1];

% Partendo dall'esercizio in simulink, uso il comando linmod che permette
% di linearizzare il sistema intorno al punto di equilibrio indicato e
% restituisce le matrici A,B,C,D. Con il comando eig posso poi calcolare
% gli autovalori
[A1,B1,C1,D1]=linmod('Es2_sim',xeq1)
autoval1=eig(A1)

[A2,B2,C2,D2]=linmod('Es2_sim',xeq2)
autoval2=eig(A2)