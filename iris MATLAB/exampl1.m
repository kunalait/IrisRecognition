clc
clear all
close all
clear all; close all; clc;
msk = [0 1/32 1/16 1/32 0;...
    1/32 1/32 1/16 1/32 1/32;...
    1/16 1/16 1/8 1/16 1/16;...
    1/32 1/32 1/16 1/32 1/32;...
    0 1/32 1/16 1/32 0]; 
%msk = ones(5,5);
%msk = msk.*(1/25); 
img_prt = double(zeros(5,5)); pic_tot = 0; 
%x = imread('D:\Study\Project 2008-09\downloads\Eye_tracking\Eye_tracking\jpg\k091.jpg'); 
x = (imread('9.bmp')); 
x2 = x;
%x = rgb2gray(imread('D:\wallpapers\ELISHA CUTHBERT\34.jpg'));
%x = rgb2gray(x); 
[m,n] = size(x); 
I1 = edge(x,'prewitt');
imshow(I1); 
y2 = x; 
for k = 1:1:5 
    for i=1:1:(m-4) 
        for j = 1:1:(n-4) 
            img_prt = double(y2(i:i+4,j:j+4)); 
            img_prt = img_prt.*msk; 
            pic_tot = uint8(round(sum(img_prt(:))));
            y(i,j) = pic_tot;
        end
    end
    [m n] = size(y);
    y2 = y;
end

figure; 
imshow(y); 
y1 = edge(y,'prewitt');
figure; imshow(y1);

%%


I = y1; 
[y,x]=find(I);
[sy,sx]=size(I);
figure;
imshow(I); 
totalpix = length(x); 
cntdn = 0; 
HM = zeros(sy,sx,50); 
R = 1:50; 
R2 = R.^2; 
sz = sy*sx; 
for cnt = 1:totalpix 
    for cntR = 1:50 
        b = 1:sy; 
        a = (round(x(cnt) - sqrt(R2(cntR) - (y(cnt) - [1:sy]).^2)));
        b = b(imag(a)==0 & a>0); 
        a = a(imag(a)==0 & a>0);
        ind = sub2ind([sy,sx],b,a);
        HM(sz*(cntR-1)+ind) = HM(sz*(cntR-1)+ind) + 1; 
        %disp(ind); 
    end
    %cntdn = cntdn + 1 
end
for cnt = 1:50 
    H(cnt) = max(max(HM(:,:,cnt))); 
end
figure; 
plot(H,'*-'); 
[maxval, maxind] = max(H);
[B,A] = find(HM(:,:,maxind)==maxval); 
figure;
I=imclearborder(I);
I=bwareaopen(I,80);
imshow(I);

hold on; 
plot(mean(A),mean(B),'xr')
        text(mean(A),mean(B),num2str(maxind),'color','green')
        s=strel('disk',10);
        I=imclose(I,[s]);
        figure,imshow(I)
        bwconncomp(I)
        [B,L]=bwboundaries(I);
        bwconncomp(I)
        figure,imshow(x2)
        hold on
%         for i=1:length(B);
%             b=B{i};
%             plot(b(:,1),b(:,2),'g');
%         end
%         
        
%%


a1=im2bw(x2,0.05);

a2=~a1;

ab=bwareaopen(a2,100);

af=imfill(ab,'holes');

reg=regionprops(af,'all');
center=reg.Centroid;



[B,L]=bwboundaries(af);
b=B{1};

d=sqrt((center(1)-b(1,2))^2+(center(2)-b(1,1))^2);
%d=49;
theta=[0:pi/200:2*pi];

 x=(center(1))+d*cos(theta);
 y=(center(2))+d*sin(theta);


d2=100;

x1=round(center(1))+d2*cos(theta);
y1=round(center(2))+d2*sin(theta);
% 
 hold on
plot(x,y,'linewidth',2)
plot(b(:,2),b(:,1),'g')
plot(x1,y1,'linewidth',2)


%%
final=0;
rad=linspace(d,d2,45);
for i=1:length(rad);
    x(i,:)=(center(1)+rad(i)*cos(theta));
    y(i,:)=(center(2)+rad(i)*sin(theta));
   % plot(x(i,:),y(i,:),'r');
    for j=1:length(theta);
        final(i,j)=x2(round(y(i,j)),round(x(i,j)));
    end

end
impixelinfo
% finalj=x2(round(x),(y));

figure,imshow(uint8(final))
impixelinfo