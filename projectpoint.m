function [ output ] = projectpoint(points,curve,pixel,featurepoint,ZLimits)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

[nearpoint(1),nearpoint(2)]=get_nearest_point([points(1,2),points(1,1)],curve);
point=points(1,:);
%projectionpoint=[featureU.maxYpoint(14,:);featureU.minYpoint(14:-1:8,:);featureU.minYpoint(1:7,:)]*Rs;
dy=zeros([size(featurepoint,1),1]);
for i=1:size(featurepoint,1)
    [featurepoint(i,2),featurepoint(i,1),dy(i)]=get_nearest_point( [featurepoint(i,2),featurepoint(i,1)],curve);
end
%get nearest featurepoint
nearp=norm(featurepoint(1,1:2)-nearpoint,2);
for i=2:size(featurepoint,1)
    tmp=norm(featurepoint(i,1:2)-nearpoint,2);
    if(tmp<nearp)
        nearp=tmp;
    else
        break;
    end
end
i=i-1;
samplepoint=pixel(i+1)-pixel(i);
% point 到feature_point(i)-i+1的距离
k=(featurepoint(i+1,1)-featurepoint(i,1))/(featurepoint(i+1,2)-featurepoint(i,2));
x=(k*point(1)+point(2)+k*k*featurepoint(i,2)-k*featurepoint(i,1))/(k*k+1);
(x-featurepoint(i,2))/(featurepoint(i+1,2)-featurepoint(i,2))
output(1,1)=floor((x-featurepoint(i,2))/(featurepoint(i+1,2)-featurepoint(i,2))*samplepoint);
output(1,2)=floor(point(3)-ZLimits)+1;
end

% a=[-15.2043 -25.6376 16.0589];
% a=a*Rs;
% projectionpoint=[featureU.maxYpoint(14,:);featureU.minYpoint(14:-1:8,:);featureU.minYpoint(1:7,:)]*Rs;
% 
% output=projectpoint(a,curve2,pixel_point.x,projectionpoint,tmp.ZLimits(1))
% [ output2,normal ] = GetbackPoint(output,curve2,pixel_point.x,projectionpoint,Rs,min(U(:,2)),tmp.ZLimits(1))

