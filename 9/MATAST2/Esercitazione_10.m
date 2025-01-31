clear all; close all; clc;

load dati2014
load dati2015
% y=load('BLA94.TEM');
% yvalid=load('BLA95.TEM');
nulldata=-999;

%% Definizione modello AR

p=1;
m=0;
n=0;
k=0;
int_cs=[5,7]
int_cat=[];
ts=0;
y=PM2014;
u=[];
ucat=[];
Toffset=3;
t=[];

yv=PM2015;
y=PM2014;
uv=[];
ucatv=[];
tv=[];
Toffsetv=4;

%[model]=ar_model(p,m,n,k,int_cs,[]) % definisce il modello
%% Rielaborazione Dataset
model=ar_model(p,m,n,k,int_cs,int_cat,ts)
[dataset_id]=ar_dataset(model,nulldata,y,u,ucat,t,Toffset)

%% Identificazione

[model_id]=ar_estimation(model,dataset_id);

%% Dataset di validazione 

%[dataset_va]=ar_dataset(model_id,nulldata,PM2015,[],[],[],4);
[dataset_va]=ar_dataset(model,nulldata,yv,uv,ucatv,tv,Toffsetv)
%% Validazione

ar_valid(model_id,dataset_va);


%% Previsione a 2 passi

steps=2;
ar_prediction(model_id,dataset_va,steps);
pause
p=1;
m=1;
n=1;
k=1;
int_cs=[]
int_cat=[];
ts=0;
y=PM2014;
u=T2014;
ucat=[];
Toffset=3;
t=[];

yv=PM2015;
uv=T2015;
ucatv=[];
tv=[];
Toffsetv=4;

[model]=ar_model(p,m,n,k) % definisce il modello
%% Rielaborazione Dataset

[dataset_id]=ar_dataset(model,nulldata,y,u,ucat,t,Toffset)

%% Identificazione

[model_id]=ar_estimation(model,dataset_id);

%% Dataset di validazione 

%[dataset_va]=ar_dataset(model_id,nulldata,PM2015,[],[],[],4);
[dataset_va]=ar_dataset(model,nulldata,yv,uv,ucatv,tv,Toffsetv)

%% Validazione

ar_valid(model_id,dataset_va);


%% Previsione a 2 passi

steps=2;
ar_prediction(model_id,dataset_va,steps);
pause

p=1;
m=0;
n=0;
k=0;
int_cs=[]
int_cat=[10];
ts=0;
y=PM2014;
u=[];
ucat=T2014;
Toffset=3;
t=[];

yv=PM2015;
uv=[];
ucatv=[T2015];
tv=[];
Toffsetv=4;

[model]=ar_model(p,m,n,k,[],int_cat) % definisce il modello
%% Rielaborazione Dataset

[dataset_id]=ar_dataset(model,nulldata,y,u,ucat,t,Toffset)

%% Identificazione

[model_id]=ar_estimation(model,dataset_id);

%% Dataset di validazione 

%[dataset_va]=ar_dataset(model_id,nulldata,PM2015,[],[],[],4);
[dataset_va]=ar_dataset(model,nulldata,yv,uv,ucatv,tv,Toffsetv)

%% Validazione

ar_valid(model_id,dataset_va);


%% Previsione a 2 passi

steps=2;
ar_prediction(model_id,dataset_va,steps);
