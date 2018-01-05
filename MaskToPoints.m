function [ points ] = MaskToPoints( mask )
%mask to n*2 point
%   此处显示详细说明
[m,n]=size(mask);
BW1=edge(mask,'sobel');
tmp=find(BW1==1);
points=zeros(size(tmp,1),2);
points(:,2)=floor(mod(tmp,m));
points(:,1)=floor((tmp-1)/m)+1;
end

