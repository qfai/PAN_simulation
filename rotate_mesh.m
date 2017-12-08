function [ mesh,center ] = rotate_mesh( mesh,axes,theta,varargin )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin==4
    center=varargin{1};
else
    center=sum(mesh)/size(mesh,1);
end
mesh=mesh-repmat(center,[size(mesh,1),1]);
%make sure the axis is unit
axes=axes/norm(axes,2);
u=axes(1);
v=axes(2);
w=axes(3);
mesh=mesh*[u^2+(1-u^2)*cos(theta),u*v*(1-cos(theta))-w*sin(theta),u*w*(1-cos(theta))+v*sin(theta);
    u*v*(1-cos(theta))+w*sin(theta),v^2+(1-v^2)*cos(theta), v*w*(1-cos(theta))-u*sin(theta);
    u*w*(1-cos(theta))-v*sin(theta),v*w*(1-cos(theta))+u*sin(theta),w^2+(1-w^2)*cos(theta)];


mesh=mesh+repmat(center,[size(mesh,1),1]);

end

