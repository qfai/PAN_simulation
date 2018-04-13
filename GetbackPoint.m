function [ output,normal ] = GetbackPoint(points,curve,pixel,projectionpoint,Rs,minu,uz)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

dy=zeros([size(projectionpoint,1),1]);
for i=1:size(projectionpoint,1)
    [projectionpoint(i,2),projectionpoint(i,1),dy(i)]=get_nearest_point( [projectionpoint(i,2),projectionpoint(i,1)],curve);
end
output=zeros(size(points,1),3);
normal=zeros(size(points,1),3);
for i=1:size(points,1)
%binary search
left=1;
right=size(pixel,1);
%x为轴找到最近的采样点
while left<right-1
    mid=floor((left+right)/2);
    if( points(i,1)==pixel(mid))
        left=mid;
        break;
    elseif(points(i,1)<pixel(mid))
         right=mid-1;
    else
       left=mid;
    end
end
    output(i,1:2)=(projectionpoint(left+1,1:2)-projectionpoint(left,1:2))*(points(i,1)-pixel(left))/(pixel(left+1)-pixel(left)+0.5)+projectionpoint(left,1:2);
    left
    (points(i,1)-pixel(left))/(pixel(left+1)-pixel(left))+0.5
    %[output(i,2),output(i,1),normal(i,1)]=get_nearest_point( [output(i,2),output(i,1)],curve);
    normal=-1*((projectionpoint(left+1,1)-projectionpoint(left,1))/(projectionpoint(left+1,2)-projectionpoint(left,2)));
    output(i,3)=points(i,2)-1-minu+uz+0.5;
    normal(i,1)=-1/normal(i,1);
    normal(i,2)=1;
    normal(i,3)=0;
end
for i=1:size(normal,1)
 normal(i,:)=normal(i,:)/norm(normal(i,:),2);
end
output=output*inv(Rs);

end

