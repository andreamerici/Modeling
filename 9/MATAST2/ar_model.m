function [model]=ar_model(p,m,n,k,cs_intervals,cat_intervals,st)
% [model]=ar_model(p,m,n,k,cs_intervals,cat_intervals,st)
% definisce il modello del sistema
%
% p: ordine parte autoregressiva 
%
% m: numero di ingressi
%
% n: vettore dei numeri di ingressi passati presi in considerazione. (uno
%    per ingresso).
%
% k: vettore dei numeri di ritardi (uno per ingresso).
%
% cs_intervals: intervalli di ciclo stazionarietà:
%               * se vuoto o non specificato, non c'è ciclostazionarietà.
%               * se scalare, indica il periodo di ciclostazionarietà. I
%                 sottoperiodi sono posti uguali a un passo di campionamento
%                 unitario.
%               * se vettore, indici la divisione in sottointervalli del
%                 periodo di ciclostazionarietà (l'ultimo valore coincide con
%                 il periodo). Ad esempio: [5 7 10] indica una ciclo
%                 stazionarietà di periodo 10 con sottointervalli di:
%                 [0 5),[5 7),[7 10) (parentesi quadra: estremo compreso,
%                 parentesi tonda: estremo escluso).
%
% cat_intervals: intervalli delle categorie: 
%                * se vuoto o non specificato, non c'è divisione in
%                  categorie.
%                * se vettore o scalare, le categorie sono divise come:
%                  (-inf cat_intervals(1)),
%                  [cat_intervals(1) cat_intervals(2)),
%                  [cat_intervals(2) cat_intervals(3)),
%                  ....
%                  [cat_intervals(end) inf)
%                  (parentesi quadra: estremo compreso, parentesi tonda: 
%                  estremo escluso). 
%
% st: passo di campionamento, se non specificato viene posto uguale a 1


if nargin<1
    error('Not enough input arguments.');
elseif nargin>7
    error('Too many input arguments.')
end
if nargin==1
    m=0;
    n=0;
    k=0;
end
if or(nargin==2,nargin==3)
    error('Se m>0, occorre specificare anche p e k');
end
if nargin<5
    cs_intervals=[];
end
if nargin<6
    cat_intervals=[];
end
if nargin<7
    st=1;
end



model.n=n;
model.m=m;
model.p=p;
model.k=k;


if and(and(isscalar(st)==0,isnumeric(st)==0),st<=0)
    error('il passo di campionamento deve essere uno scalare positivo')
end

if isempty(cs_intervals) % se non definito o vuoto, nessuna ciclostazionarietà
    model.cs_intervals=cs_intervals;
elseif and(isscalar(cs_intervals),cs_intervals>0) % se scalare: vedi help introduttivo
    if isinteger(cs_intervals-floor(cs_intervals)) % se non è intero
        cs_intervals=round(cs_intervals);
        warning('Se cs_intervals è scalare, esso è uguale al periodo di ciclostazionarietà con sottointervalli sono pari a un singolo passo. cs_intervals deve essere quindi un intero.')
    end
    model.cs_intervals(:,1)=(1:1:(cs_intervals))';
    model.cs_intervals(:,2)=(1:1:(cs_intervals))';
elseif (isvector(cs_intervals)) %se vettore: vedi help introduttivo
    if sum(diff(cs_intervals)<st) %se non è un vettore di valori crescenti
        error('cs_intervals deve essere composto solo da valori strettamente crescenti');
    end
    if cs_intervals(1)<=0
    	error('cs_intervals deve essere composto solo da valori strettamente positivi');
    end
    model.cs_intervals(1,:)=[1 cs_intervals(1)];
    for index=2:length(cs_intervals)
        model.cs_intervals(index,:)=[cs_intervals(index-1)+1 cs_intervals(index)];
    end
else
    error('cs_intervals non corretto');
end

if isempty(cat_intervals) % se non definito o vuoto, nessuna divisione in categorie
    model.cat_intervals=cat_intervals;
elseif isvector(cat_intervals) %se è un vettore
    if sum(diff(cs_intervals)<0) %se non è un vettore di valori crescenti
        error('cat_intervals deve essere composto solo da valori strettamente crescenti');
    end
    model.cat_intervals(1,:)=[-inf cat_intervals(1)];
    for index=2:length(cat_intervals)
        model.cat_intervals(index,:)=[cat_intervals(index-1) cat_intervals(index)];
    end
    model.cat_intervals(end+1,:)=[cat_intervals(end) inf];
else
    error('cat_intervals non corretto');
end


model.numcat=max(1,length(model.cat_intervals)); %numero categorie
model.numcs=max(1,length(model.cs_intervals)); %numero di ciclostazionarietà
if model.numcs>=2
    model.period=cs_intervals(end,end); %periodo di ciclostazionarietà
else
    model.period=inf;
end


if ~isscalar(p)
    error('n non è scalare')
end
if ~isscalar(m)
    error('m non è scalare')
end
if or(~isvector(n),~length(n))
    error('p non è un vettore delle dimensioni corrette')
elseif(size(n,1))==1
        n=n';
end
if or(~isvector(k),~length(k))
    error('k non è un vettore delle dimensioni corrette')
elseif(size(k,1))==1
        k=k';
end



order=max([n;p+k]);

model.order=order; %ordine del sistema (massimo ritardo)

