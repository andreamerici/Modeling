function [h]=ar_displaymodel(model,dataset,verbose)
% model: modello creato con ar_model.m
% dataset: dataset in ingresso
% timeoffset: offset nel vettore dei tempi (per modelli ciclostazionari)
% % verbose: * se uguale a 1, o se non fornito, stampa a video il modello
%              e gli indicatori, e grafica i risultati
%            * se uguale a 2 stampa a video il modello e gli indicatori,
%              senza i grafici
%            * se uguale a 3 stampa a video solo il modello
%            * se uguale a 4 stampa a video solo gli indicatori
%            * se uguale a 5 grafica solo i risultati

if nargin<1
    error('Not enough input arguments.')
end
if nargin<2
    dataset=[];
end
if nargin<3
    verbose=1;
end
if nargin>4
    error('Too many input arguments.')
end

n=model.n;
m=model.m;
p=model.p;
k=model.k;

for index_cs=1:model.numcs
    for index_cat=1:model.numcat
        fprintf('%s\n',repmat('-',1,50));
        if model.numcs>1
            fprintf('Intervallo di Ciclostazionarietà [%d %d] con periodo T=%d',model.cs_intervals(index_cs,1),model.cs_intervals(index_cs,2),model.period)
            if model.numcat>1
                fprintf(',\t')
            else
                fprintf('\n');
            end
        end
        if model.numcat>1
            fprintf('Categoria [%d %d) \n',model.cat_intervals(index_cat,1),model.cat_intervals(index_cat,2))
        end
        
        if verbose<=3
            %% presenta il modello
            fprintf('y(t)=\n')
            
            parameters=model.submodel(index_cs,index_cat).parameters;
            confidenceinterval=model.submodel(index_cs,index_cat).confidenceinterval;
            
            for index=1:p
                fprintf('%-+6.3f ',parameters(index));
                fprintf('* y(t-%d) \t',index)
                fprintf('[± %5.4f]\n',confidenceinterval(index))
                
            end
            for index_m=1:m % per tutti gli ingressi
                for index_n=1:n(index_m) %per tutti i coefficienti dell''ingresso um
                    fprintf('%-+6.3f ',parameters(p+sum(n(1:(index_m-1)))+index_n));
                    fprintf('* u%d(t-%d) \t',index_m,index_n+k(index_m))
                    fprintf('[± %5.3f]\n',confidenceinterval(p+sum(n(1:(index_m-1)))+index_n))
                end
            end
            if (parameters(end)>0)
                fprintf('+')
            end
            fprintf('%-6.3f \t\t\t\t',parameters(end));
            fprintf('[± %5.3f]\n',confidenceinterval(end))
            fprintf('+e(t)\n\n');
            
            fprintf('Autovalori: \n');
            autoval=model.submodel(index_cs,index_cat).eigvalues;
            for indexAutoval=1:length(autoval)
                if isreal(autoval(indexAutoval))
                    fprintf('%-+6.2f\n',autoval(indexAutoval));
                else
                    fprintf('%-+6.2f%-+6.2fi\n',real(autoval(indexAutoval)),imag(autoval(indexAutoval)));
                end
            end
            fprintf('\n');
        end
        
        if or(verbose==1,or(verbose==2,verbose==4));
            %% indicatori statistici
            if and(or(model.numcs>1,model.numcat>1),isempty(dataset)==0)
                indexes=(dataset.csDirty==index_cs).*(dataset.catDirty==index_cat);
                fprintf('Indicatori statistici sottomodello:\n');
                ar_statistics(dataset.zDirty(indexes==1),dataset.zModelDirty(indexes==1),1);
                fprintf('%s\n',repmat('-',1,50));
            end
        end
    end
end

if or(verbose==1,or(verbose==2,verbose==4));
    if isempty(dataset)==0
        fprintf('Indicatori statistici modello completo\n');
        ar_statistics(dataset.zDirty,dataset.zModelDirty,1);
        fprintf('%s\n',repmat('-',1,50));
    end
    fprintf('\n\n')
end

if or(verbose==1,verbose==5);
    h=figure;
    plot(dataset.zDirty,'-k');
    hold on
    plot(dataset.zModelDirty,'-.b');
    legend('Real data','Model Data');
else
    h=[];
end