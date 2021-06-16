function [model]=ar_estimation(model,dataset,verbose)
% stima i coefficienti del modello con il metodo dei minimi quadrati
% model: modello creato con ar_model.m
% daset: dataset da usare nell'identificazione
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



for index_cs=1:model.numcs
    for index_cat=1:model.numcat
        indexes=find((dataset.cat==index_cat).*(dataset.cs==index_cs));
        An=dataset.An(indexes,:);
        z=dataset.z(indexes,:);
        if isempty(An)
            error('non esistono dati relativi al sottomodello')
        end
        parameters=pinv(An)*z;
        residuals=z-An*parameters;
        
        if (length(residuals)-length(parameters))<=0
            warning('Il numero di parametri è uguale o maggiore dei dati disponibili!')
        end
        sigma0=(residuals'*residuals)/(length(residuals)-length(parameters)); % stima varianza dei rumore (supposto uguale per ogni misura) %cambia nome in varsigma0
        matvar_parameters=sigma0*inv(An'*An); %#ok<MINV> %matrice covarianza parametri
        sigma_parameters=sqrt(diag(matvar_parameters)); %deviazione standard parametri
        confidenceinterval=tinv(0.975,(length(residuals)-length(parameters)))*sigma_parameters; %intervallo di confidenza al 97.5% dei parametri
        
        
        poliden=[1;-parameters(1:model.p)]'; %polinomio a denominatore
        eigenvalues=roots(poliden);
        
        submodel(index_cs,index_cat).parameters=parameters; %#ok<*AGROW>
        submodel(index_cs,index_cat).residuals=residuals;
        submodel(index_cs,index_cat).matvar_parameters=matvar_parameters;
        submodel(index_cs,index_cat).sigma_parameters=sigma_parameters;
        submodel(index_cs,index_cat).sigma0=sigma0;
        submodel(index_cs,index_cat).confidenceinterval=confidenceinterval/2;
        submodel(index_cs,index_cat).isstable=(sum(abs(eigenvalues)>1))==0; % se il numero di autovalori con modulo maggiore di uno è 0
        submodel(index_cs,index_cat).eigvalues=eigenvalues;
    end
end
model.submodel=submodel;

if verbose
    fprintf('\tIDENTIFICAZIONE DEL MODELLO\n')
    [dataset]=ar_sim(model,dataset);
    h=ar_displaymodel(model,dataset);
    set(h,'Name','IDENTIFICAZIONE DEL MODELLO');
    title('IDENTIFICAZIONE DEL MODELLO');
end