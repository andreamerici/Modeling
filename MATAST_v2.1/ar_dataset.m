function [dataset]=ar_dataset(model,nulldata,y,u,ucat,t,timeoffset)
% model: modello creato con ar_model.m
% nulldata: valore da escludere (se vuoto è posto a NaN)
% y: output del modello (vettore colonna)
% u: input del modello (matrice con m colonne);
% t: vettore dei tempi
% timeoffset: offset nel vettore dei tempi (per modelli ciclostazionari)


%% controllo il numero di ingressi
if or(and(model.m>0,nargin<4),and(model.m==0,nargin<3))
    error('Not enough input arguments.');
elseif nargin>7
    error('Too many input arguments.')
end
if nargin<4
    u=[];
end
if nargin<5
    t=[];
end
if nargin<6
    timeoffset=0;
end

if isempty(nulldata)
    nulldata=NaN;
end

n=model.n;
m=model.m;
p=model.p;
k=model.k;
cs_intervals=model.cs_intervals;
cat_intervals=model.cat_intervals;
order=model.order;


%% controllo le dimensioni di y,u,t
if ~isvector(y)
    error('y non è una colonna')
end
if size(y,1)==1
    y=y';
end

if size(u,2)~=m
    error('u non ha dimensioni corrette')
end

if isempty(t)
    t=(1:length(y))';
else
    if or(size(t,2)~=1)
        if size(t,1)==1
            t=t';
        else
            error('t non ha dimensioni corrette')
        end
    end
end

t=t; %offset temporale

if m>0
    numerodati=min([length(y),length(u),length(t)]);
    y=y(1:numerodati,:);
    u=u(1:numerodati,:);
    t=t(1:numerodati,:);
end


%% costruisco le matrici z (uscite attuali) e An (passato) del dataset

% 1) parte autoregressiva
z=y((order+1):length(y));
t=t((order+1):length(y));

An=[];
for index=1:p
    An=[An y(((order+1):length(y))-index)];
end
% 2) parte esogena
for index_m=1:m
    for index=(k(index_m)+(1:n(index_m)))
        An=[An u((order+1:length(y))-index,index_m)];
    end
end
An=[An,ones(size(An,1),1)]; %termine di depolarizzazione

% 3) scarto dati non validi
nullindexes= (z==nulldata);
z(z==nulldata)=NaN;
for index=1:size(An,2) %per ogni colonna
    nullindexes=nullindexes+(An(:,index)==nulldata);
    An(An(:,index)==nulldata,index)=NaN;
end
validindexes=(nullindexes==0); %indici validi

% nota: Dirty-> dati con valori non validi
dataset.AnDirty=An;
dataset.tDirty=t;
dataset.zDirty=z;
dataset.validindexes=validindexes;

%% divido in categorie
if model.numcat<2
    dataset.catDirty=ones(length(An),1);
elseif n==0
    ucat=ucat(order+1:length(y));
    %ucat=ucat(validindexes);
    for index=1:model.numcat
        indexes=find((ucat>=cat_intervals(index,1)).*(ucat<cat_intervals(index,2)));
        dataset.catDirty(indexes,1)=index;
    end
else
    ucat=ucat(((order+1):length(y))-1);
    %ucat=ucat(validindexes);
    for index=1:model.numcat
        indexes=find((ucat>=cat_intervals(index,1)).*(ucat<cat_intervals(index,2)));
        dataset.catDirty(indexes,1)=index;
    end
end

%% divido in intervalli di ciclostazionarietà
if model.numcs<2
    dataset.csDirty=ones(length(An),1);
else
    tmod=mod(dataset.tDirty,model.period)+1; %rimodulo il tempo sul periodo (partendo come primo valore da 1).
    for index=1:model.numcs
        indexes=find((tmod>=cs_intervals(index,1)).*(tmod<=cs_intervals(index,2)));
        dataset.csDirty(indexes,1)=index;
    end
end

dataset.csDirty=circshift(dataset.csDirty,1-timeoffset);
%%
An=An(validindexes,:); %mantengo solo gli indici validi
z=z(validindexes,:);
dataset.An=An;
dataset.z=z;
dataset.t=t(validindexes,:);
dataset.cs=dataset.csDirty(validindexes,:);
dataset.cat=dataset.catDirty(validindexes,:);
