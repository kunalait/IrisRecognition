function [A B]=codingeye(final)

global Ah6
global Av6
%%
% Divide normalized iris images into basic cells of dimension 3x7
CELL={};
nr=3;mr=7;
k=1;l=1;
for i=1:nr:size(final,1)-(nr-1)
    for j=1:mr:size(final,2)-(mr-1)
        CELL{k,l}=uint8(final(i:i+(nr-1),j:j+(mr-1)));
        l=l+1;
    end
    k=k+1;
    l=1;
end

%% 
% for every cell a unique average grey value must be found
G={};
for i=1:size(CELL,1)
    for j=1:size(CELL,2)
        G{i,j}=mean2(CELL{i,j});
    end
end
BT=cell2mat(G);
%%
% finding unique average of every distinct group horizontally first
% and then finding the group vertically
HX={};u=1;
VX={};v=1;
for i=1:size(BT,1);
    for j=1:5:size(BT,2)-4;
        HX{u,v}=mean(BT(i,j:j+4));v=v+1;
    end
    u=u+1;v=1;
end
H_newX=cell2mat(HX);
%% vertical mean finding
v=1;
u=1;
for j=1:size(BT,2)
    for i=1:5:size(BT,1)-4
        VX{u,v}=mean(BT(i:i+4,j));
        u=u+1;
    end
    v=v+1;u=1;
end
V_newX=cell2mat(VX);
%%
HCX=zeros(size(BT));
VCX=zeros(size(BT));
u=1;v=1;
S=zeros(1,6);
for i=1:size(BT,1)
    for j=1:5:size(BT,2)-4
        T=BT(i,j:j+4);
        for k=2:6
            S(k)=(T(k-1)-H_newX(u,v))+S(k-1);
        end
        HCX(i,j:j+4)=S(2:6);
        v=v+1;
    end
    u=u+1;
    v=1;
end
%%
S=zeros(1,6);
u=1;v=1;
for j=1:(size(BT,2))
    for i=1:5:size(BT,1)-4
        T=BT(i:i+4,j);
        for k=2:6
            S(k)=(T(k-1)-V_newX(u,v))+S(k-1);
        end
        VCX(i:i+4,j)=S(2:6);
        u=u+1;
    end
    v=v+1;
    u=1;
end
%% generating iris codes
% horizontally
Ah=zeros(size(VCX));
Av=zeros(size(VCX));
TG=zeros(1,5);
for i=1:size(VCX,1)
    for j=1:5:size(VCX,2)-4
        T=HCX(i,j:j+4);
        [mn,imn]=min(T);
        [mx,imx]=max(T);
        if imn<imx
           TG(imn:imx)=1;
        elseif imx<imn
            TG(imx:imn)=2;
        end
        Ah(i,j:j+4)=TG;
    end
end
% figure(5),imagesc((Ah))
A=Ah;

%%
% vertically
% Ah=zeros(size(VCX));
Av=zeros(size(VCX));
TG=zeros(1,5);
for j=1:size(VCX,2)
    for i=1:5:size(VCX,1)-4
        T=VCX(i:i+4,j);
        [mn,imn]=min(T);
        [mx,imx]=max(T);
        if imn<imx
           TG(imn:imx)=1;
        elseif imx<imn
            TG(imx:imn)=2;
        end
        Av(i,j:j+4)=TG;
    end
end
B=Av;