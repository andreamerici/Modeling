clear all; close all; clc;

load identificazione_2 %y,u,t
load validazione_2 %yvalid,uvalid,tvalid

% y=load('BLA94.TEM');
% yvalid=load('BLA95.TEM');
nulldata=9999.99;

%% Definizione modello AR

p=1;
[model]=ar_model(p) % definisce il modello

%% Rielaborazione Dataset

[dataset_id]=ar_dataset(model,nulldata,y)

%% Identificazione

[model_id]=ar_estimation(model,dataset_id);

%% Dataset di validazione 

[dataset_va]=ar_dataset(model_id,nulldata,yvalid);

%% Validazione

ar_valid(model_id,dataset_va);


%% Previsione a 2 passi

steps=2;
ar_prediction(model_id,dataset_va,steps);


%% Definizione modello ARX(2,1,1)

p=2;
m=1;
n=1;
k=1 ;
[model]=ar_model(p,m,n,k) % definisce il modello

%% Rielaborazione Dataset

[dataset_id]=ar_dataset(model,nulldata,y,u)


%% Identificazione

[model_id]=ar_estimation(model,dataset_id);

%% Dataset di validazione 

[dataset_va]=ar_dataset(model_id,nulldata,yvalid,uvalid);

%% Validazione

ar_valid(model_id,dataset_va);


%% Previsione a 2 passi

steps=2;
ar_prediction(model_id,dataset_va,steps);
