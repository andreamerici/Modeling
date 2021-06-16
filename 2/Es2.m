clear all
xeq1=[0 0];
xeq2=[2 1];

[A1,B1,C1,D1]=linmod('Es2_sim',xeq1)
eig(A1)

[A2,B2,C2,D2]=linmod('Es2_sim',xeq2)
eig(A2)
