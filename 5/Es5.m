clear all
xeq1=[1 0];
xeq2=[-1 2];
xeq3=[-2 2];

x0=[-1.5 -1.5];

[A1,B1,C1,D1]=linmod('es5b_sim',xeq1);
eig(A1)

[A2,B2,C2,D2]=linmod('es5b_sim',xeq2);
eig(A2)

[A3,B3,C3,D3]=linmod('es5b_sim',xeq3);
eig(A3)