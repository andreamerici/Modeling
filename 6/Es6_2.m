clear all
p=5;
xeq1=[sqrt(p-1) -p];
xeq2=[-sqrt(p-1) -p];

J=@(x)[2*x(1) 1;0 2*x(2)+p-2];

J(xeq1)
J(xeq2)
x0=[-4 -8]

[A1,B1,C1,D1]=linmod('Es6_sim',xeq1);
eig(A1)

[A2,B2,C2,D2]=linmod('Es6_sim',xeq2);
eig(A2)