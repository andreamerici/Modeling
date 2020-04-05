function [dataset]=ar_sim(model,dataset,steps)
% esegue la simulazione del modello per "steps" passi
% model: modello creato con ar_model.m
% dataset: nome del dataset da usare per la simulazione
% steps: numero di passi.


if nargin<2
    error('Not enough input arguments.');
elseif nargin>3
    error('Too many input arguments.');
end
if nargin<3
    steps=1;
end

if and(model.m>0,steps>min(model.k+1))
    error(['Non è possibile effettuare una previsione a ',num2str(steps),' passi con il modello considerato']);
end

p=model.p;
An=dataset.AnDirty;
t=dataset.tDirty;
znew=zeros(size(t));
for index=1:steps
    for index2=1:size(An,1)
        cs=dataset.csDirty(index2);
        cat=dataset.catDirty(index2);
        if (or(cs==0,cat==0))
            znew(index2,1)=NaN;
        else
            znew(index2,1)=An(index2,:)*model.submodel(cs,cat).parameters;
        end
    end
    
    if index<steps
        An(1:end,1:p)=[nan(1,p);znew(1:end-1) An(1:end-1,1:p-1)]; %aggiorno la parte di An che dipende da y con i nuovi valori predetti. La prima riga viene posta a NaN perchè non è predicibile
    end
end


dataset.zModelDirty=znew;
dataset.tModelDirty=t;

nullindexes=isnan(dataset.zModelDirty); %pulisco i dati dai NaN
dataset.tModel=dataset.zModelDirty(nullindexes==0);
dataset.zModel=dataset.zModelDirty(nullindexes==0);

