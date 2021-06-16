function [dataset]=ar_valid(model,dataset)
% validazione
% model: modello creato con ar_model.m
% daset: dataset da usare nella validazione
% verbose: se diverso da zero, o se non fornito, stampa a video il modello 
% e gli indicatori

 
if nargin<2
    error('Not enough input arguments.');
elseif nargin>3
    error('Too many input arguments.');
end
if nargin<3
    verbose=1;
end

[dataset]=ar_sim(model,dataset);
if verbose
    fprintf('\tVALIDAZIONE DEL MODELLO\n')
    h=ar_displaymodel(model,dataset);
    set(h,'Name','VALIDAZIONE DEL MODELLO');
    title('VALIDAZIONE DEL MODELLO');
end
