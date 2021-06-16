function [dataset]=ar_prediction(model,dataset,steps,verbose)
% previsione a n-passi
% model: modello creato con ar_model.m
% daset: dataset da usare nella validazione
% steps: numero di passi.
% verbose: se diverso da zero, o se non fornito, stampa a video il modello 
% e gli indicatori

if nargin<2
    error('Not enough input arguments.');
end
if nargin<3
    steps=1;
end
if nargin<4
    verbose=1;
end
if nargin>4
    error('Too many input arguments.');
end

[dataset]=ar_sim(model,dataset,steps);
if verbose
    if steps>1
        stringa1=sprintf('PREVISONE DEL MODELLO A %d PASSI',steps);
    else
        stringa1=sprintf('PREVISONE DEL MODELLO A UN PASSO');
    end

    fprintf('\t%s\n',stringa1)    
    h=ar_displaymodel(model,dataset);
    set(h,'Name',stringa1);
    title(stringa1);
end


