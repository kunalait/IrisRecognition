
global Ah6
global Av6
%%
%Loading image 
clc
clear all
close all
a=(imread('8.bmp'));
imshow(a);
%%
%preprocessing
figure
[r,c,w]=size(a);
if w==3
a=rgb2gray(a);
end
a1=im2bw(a,0.2);

imshow(a1), figure

% a1=im2bw(a,0.1);
% 
% a1=im2bw(a,0.05);

%colour inversion
a2=~a1;
imshow(a2)
%%
%removal of noise
ab=bwareaopen(a2,200);
close all
 %for i=1:5
 s=strel('disk',2);
 ab=imdilate(ab,s);
af=imfill(ab,'holes');
figure,imshow(af)
 %end
close all
af=imclearborder(af);
imshow(af)
%%
%obtaining various properties of the image such as area,centroid,etc.
reg=regionprops(af,'all');
center=reg.Centroid;
close all
hold on

%alpha(0.5);
imshow(a);
%as=@(x) imadjust(x,[],[],0.3);
%aj=roifilt2(a(:,:,1),af,as);
%hold on
%close all
%imshow(aj)
% alpha(0.5)
shg
%% daugman rubbersheet model
[B,L]=bwboundaries(af);
b=B{1};

d=sqrt((center(1)-b(1,2))^2+(center(2)-b(1,1))^2);

theta=[linspace(0,35,150) linspace(110,200,150)];
x=center(1)+d*cos(theta);
y=center(2)+d*sin(theta);

d2=90;

% x1=center(1)+d2*cos(theta);
% y1=center(2)+d2*sin(theta);

% axa=a(:,:,1);
imshow(a)
hold on
%plot(x,y,'linewidth',2)
%plot(b(:,2),b(:,1),'g')
%shg
plot(center(1),center(2),'ro','linewidth',2)

final=0;
rad=linspace(d,d2,64);
[r,c]=size(a);
for i=1:length(rad);
    xa(i,:)=round(center(1)+rad(i)*cosd(theta));
    ya(i,:)=round(center(2)+rad(i)*sind(theta));
    plot(xa(i,:),ya(i,:),'r');
    for j=1:length(theta);
        if ya(i,j)<=r && xa(i,j)<c
        final(i,j)=a((ya(i,j)),(xa(i,j)));
        end
    end

end
impixelinfo
% finalj=x2(round(x),(y));

figure,imshow(uint8(final))
impixelinfo

[Ah6 Av6]=codingeye(final);
% figure(6),imagesc((Av))
save('Ahh6','Ah6');
save('Avv6','Av6');





