function [ Rs,Ts,Ri,Ti,scale ] = RegisterbyIterTheta( MeshPoints,panpoints,MeshL,panL)
%meshpoints is n*3, panpoints is n*2,and is all original
%point,theta is rotated by y axes
%scale is from x direction    
scale=(panpoints(1,1)-panpoints(10,1))/(MeshPoints(1,2)-MeshPoints(10,2));
scale=11.306;
scaledpoint=MeshPoints*scale;
cost=sum((panpoints(:,2)-repmat(panpoints(1,2),[size(panpoints,1),1])-scaledpoint(:,3)+repmat(scaledpoint(1,3),[size(scaledpoint,1),1])).^2)
mincost=cost;
mintheta=0;


for theta=-1.57:0.05:1.57
    R=[cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
    tmp=scaledpoint*R;
    midre=(panpoints(:,2)-repmat(panpoints(1,2),[size(panpoints,1),1])-tmp(:,3)+repmat(tmp(1,3),[size(tmp,1),1]));
    if(size(find(midre<0),1)>=1)
        continue;
    end
    cost=(sum(midre).^2);
    if(cost<mincost)
        mincost=cost;
        mintheta=theta;
    end
end
%get scale
% scaledpoint=scaledpoint*[cos(mintheta),0,sin(mintheta);0,1,0;-sin(mintheta),0,cos(mintheta)];
% scales=(panpoints(2:18,2)-repmat(panpoints(1,2),[size(panpoints,1)-1,1]))./(scaledpoint(2:18,3)-repmat(scaledpoint(1,3),[size(scaledpoint,1)-1,1]));
% s=sum(scales)/size(scales,1)
% scale=scale*s;
% scaledpoint=MeshPoints*scale;
% cost=sum((panpoints(:,2)-repmat(panpoints(1,2),[size(panpoints,1),1])-scaledpoint(:,3)+repmat(scaledpoint(1,3),[size(scaledpoint,1),1])).^2)
% mincost=cost;
% mintheta=0;
% for theta=minutheta:0.05:maxtheta
%     R=[cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
%     tmp=scaledpoint*R;
%     midre=(panpoints(:,2)-repmat(panpoints(1,2),[size(panpoints,1),1])-tmp(:,3)+repmat(tmp(1,3),[size(tmp,1),1]));
%     if(size(find(midre<0),1)>=1)
%         continue;
%     end
%     cost=(sum(midre).^2);
%     if(cost<mincost)
%         mincost=cost;
%         mintheta=theta;
%     end
% end
% %get scale
%  scaledpoint=scaledpoint*[cos(mintheta),0,sin(mintheta);0,1,0;-sin(mintheta),0,cos(mintheta)];
%  scales=(panpoints(2:18,2)-repmat(panpoints(1,2),[size(panpoints,1)-1,1]))./(scaledpoint(2:18,3)-repmat(scaledpoint(1,3),[size(scaledpoint,1)-1,1]));
% s=sum(scales)/size(scales,1)

mintheta
 Rs=[cos(mintheta),0,sin(mintheta);0,1,0;-sin(mintheta),0,cos(mintheta)]*(scale*eye(3));
 scaledpoint=scaledpoint*[cos(mintheta),0,sin(mintheta);0,1,0;-sin(mintheta),0,cos(mintheta)];
 Ts=[0,panpoints(1,1)-scaledpoint(1,2),panpoints(1,2)-scaledpoint(1,3)];
 
 scaledpoint=MeshPoints*Rs;
 MeshL=MeshL*scale;
cost=sum((-panL(:,2)+panpoints(:,2)-MeshL(:,3)+scaledpoint(:,3)).^2);
mincost=cost;
mintheta=0;
for theta=-1.57:0.1:1.57
    R=[cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
    tmp=MeshL*R;
    cost=sum((-panL(:,2)+panpoints(:,2)-tmp(:,3)+scaledpoint(:,3)).^2);
    if(cost<mincost)
        mincost=cost;
        mintheta=theta;
    end
end
mintheta
Ri=[cos(mintheta),0,sin(mintheta);0,1,0;-sin(mintheta),0,cos(mintheta)]*(scale*eye(3));
MeshL=MeshL*[cos(mintheta),0,sin(mintheta);0,1,0;-sin(mintheta),0,cos(mintheta)];
 Ti=[0,	panL(1,1)-MeshL(1,2),panL(1,2)-MeshL(1,3)];
 
end

