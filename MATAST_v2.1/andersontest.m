function [h,p]=andersontest(x,alpha)
x=x-mean(x);
if nargin==1
    alpha=0.05;
end
xsort=sort(x);
k=(1:length(x))';
mux=mean(xsort);
stdx=std(xsort);
xnorm=(xsort-mux)/stdx; %normalizzo a 1.

F1=normcdf(xnorm);
F2=sort(1-F1);
S=(2*k-1).*(log(F2)+log(F1));

aux1=norminv((k-3/8)/(max(k)+1/4),mux,stdx);
aux2=(k-3/8)/(max(k)+1/4);

AD=-sum(S)/max(k)-max(k);
AD2=AD*(1+.75/max(k)+2.25/max(k)^2);

if and(AD2>=0.6,AD2<3)
    p=exp(1.2937-5.709*AD2+0.0186*AD2^2);
elseif and(AD2<0.6,AD2>=0.34)
    p=exp(0.9177-4.279*AD2-1.38*AD2^2);
elseif and(AD2<0.34,AD2>0.2)
    p=1-exp(-8.318+42.796*AD2-59.938*AD2^2);
elseif AD2<0.2
    p=1-exp(-13.436+101.14*AD2-223.73*AD2^2);
else
    p=alpha;
end

h=(p>=alpha);
    