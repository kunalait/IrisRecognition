clc
clear all
close all
load Ah6
load Av6

load Ahnew
load Avnew

[r,c]=size(Ahnew);
N=r*c;
Hd=1/(2*N)*(sum(sum(xor(Ahnew,Ah6)))+sum(sum(xor(Avnew,Av6))))

if Hd<=0.0032
    disp('detected');
else
    disp('not detected');
end;
    
