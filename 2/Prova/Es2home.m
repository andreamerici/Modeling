clear all
xeq1=[0 0];
xeq2=[-1 1];
xeq3=[2 4];

[A1,B1,C1,D1]=linmod('Es2home_sim',xeq1)
eig(A1)

[A2,B2,C2,D2]=linmod('Es2home_sim',xeq2)
eig(A2)

[A3,B3,C3,D3]=linmod('Es2home_sim',xeq3)
eig(A3)
