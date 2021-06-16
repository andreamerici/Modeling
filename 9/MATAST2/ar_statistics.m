function [performance]=ar_statistics(ymeasure,ymodel,verbose)
% [performance]=ar_statistics(ymeasure,ymodel,verbose)
% fornisce indicatori statistici delle prestazioni del modello
% 
% ymeasure: dati misurati
% ymodel: dati forniti dal modello
% verbose: se diverso da zero, o se non fornito, stampa a video gli
% indicatori

if nargin<2
    error('Not enough input arguments.');
elseif nargin>3
    error('Too many input arguments.');
end
if nargin<3
    verbose=1;
end

nullindexes=or(isnan(ymodel),isnan(ymeasure)); %pulisco i dati dai NaN

ymeasure=ymeasure(nullindexes==0);
ymodel=ymodel(nullindexes==0);


residuals=ymeasure-ymodel;
performance.meanerror=mean(residuals);
performance.meanabserror=mean(abs(residuals));
performance.std=std(residuals);
performance.unexpvar=var(residuals)/var(ymodel); %unexplained variance
performance.corr=corr(ymodel,ymeasure);
performance.iswhite=andersontest(residuals,.01);
performance.useddata=length(ymodel);

if verbose
fprintf('E(e(t))=%5.2f\n',performance.meanerror);
fprintf('sqm(e(t))=%5.2f\n',performance.std);
fprintf('Var(e(t))/Var(y(t))=%5.2f\n',performance.unexpvar);
fprintf('Corr V.-P.=%5.2f\n',performance.corr);
fprintf('Dati Usati= %d\n',performance.useddata);
if performance.iswhite==1
    fprintf('White noise Test Ok\n');
else
    fprintf('White noise Test NO\n');
end
end