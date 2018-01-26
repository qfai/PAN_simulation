function [ coord ] = getcoord( theta,center,point)
%point is N*2,center 1*2,theta is scalar,by hudu 
%   此处显示详细说明
coord=zeros(size(point,1),1);
k=-1/tan(theta);
tmp=k*k+1;

for i=1:size(point,1)
    coord(i)=(k*point(i,2)-point(i,1)-k*center(2)+center(1))/sqrt(tmp);
    if (([point(i,2)-center(2),point(i,1)-center(1)]).*[1,k])<0
        coord(i)=floor(-1*coord(i));
    else
          coord(i)=floor(coord(i));
    end
end
end
%%%%%%%%%%%%%%%%% need to consider if it is negative
%test here

% I = zeros(100,100);
% I(25:25, 25:75) = 1;
% [R,xp] = radon(gpuArray(I),30);
% coord=getcoord(pi/6,[50,50],[25,25;25,75]);
% xp(max(find(R>0)))
% xp(min(find(R>0)))