%% get point

% figure;
%   scatter(Lpoints(:,1),size(paranoimg,1)-Lpoints(:,2),'.');hold on;
% scatter(Upoints(:,1),size(paranoimg,1)-Upoints(:,2),'.');hold on;
% %scatter(marked(:,1)+1+pixel_point.x(1),size(paranoimg,1)-(marked(:,2)+max(L(:,2))-max(marked(:,2))),'r*');
% scatter(U(:,1),size(paranoimg,1)-U(:,2),'b*');
% scatter(L(:,1),size(paranoimg,1)-L(:,2),'b*');
% 
% scatter(Uroot(:,1),Uroot(:,2),'r*');
% scatter(Lroot(:,1),Lroot(:,2),'r*');
% 
% scatter(pixel_point.x,pixel_point.y,'k*');
% f=imshow(paranoimg);set(f,'AlphaData',0.5);axis on

% find the point that is less than the query point, and interpolation
% between it with after point.

%assume the first pixel_point.x is less than any root point, while the last
%pixel_point.x is greater than any root point
featureU.minYpoint(14,2)=featureU.maxYpoint(13,2);
projectionpoint=[featureU.maxYpoint(14,:);featureU.minYpoint(14:-1:8,:);featureU.minYpoint(1:7,:)]*Rs;
dy=zeros([size(projectionpoint,1),1]);
for i=1:size(projectionpoint,1)
    [projectionpoint(i,2),projectionpoint(i,1),dy(i)]=get_nearest_point( [projectionpoint(i,2),projectionpoint(i,1)],curve2);
end
rootpoints=zeros(size(Uroot,1),3);
rootnormal=zeros(size(Uroot,1),3);
for i=1:size(Uroot,1)
%binary search
left=1;
right=size(pixel_point.x,1);

while left<right-1
    mid=floor((left+right)/2);
    if( Uroot(i,1)==pixel_point.x(mid))
        left=mid;
        break;
    elseif(Uroot(i,1)<pixel_point.x(mid))
         right=mid-1;
    else
       left=mid;
    end
end
    rootpoints(i,1:2)=(projectionpoint(left+1,1:2)-projectionpoint(left,1:2))*(Uroot(i,1)-pixel_point.x(left))/(pixel_point.x(left+1)-pixel_point.x(left))+projectionpoint(left,1:2);
    [rootpoints(i,2),rootpoints(i,1),rootnormal(i,1)]=get_nearest_point( [rootpoints(i,2),rootpoints(i,1)],curve2);
    rootpoints(i,3)=size(paranoimg,1)-Uroot(i,2)-min(U(:,2))+uz;
    rootnormal(i,1)=-1/rootnormal(i,1);
    rootnormal(i,2)=1;
    rootnormal(i,3)=0;
end
figure;
scatter(projectionpoint(:,2),projectionpoint(:,1),'r*');hold on
scatter(rootpoints(:,2),rootpoints(:,1),'b*');
plot(curve2,'m');


% vertex=[];
% for i=1:7
%     vertex=[vertex;Mesh.UL{i};Mesh.UR{i}];
% end
% tmp=pointCloud(vertex);
% refpoint=featureU.point*Rs;
% figure;
% pcshow(tmp);hold on;
% scatter3(rootpoints(:,1),rootpoints(:,2),rootpoints(:,3),'r*');
% scatter3(refpoint(:,1),refpoint(:,2),refpoint(:,3),'r*');
% %验证 rootpoint跟特征点差不多在一起，

for i=1:size(rootnormal,1)
 rootnormal(i,:)=rootnormal(i,:)/norm(rootnormal(i,:),2);
end
rootpoint=rootpoints*inv(Rs);
constc=10;
point1=rootpoint-constc*rootnormal;
point2=constc*rootnormal+rootpoint;
vertex=[];
for i=1:7
    vertex=[vertex;UL{i};UR{i}];
end
refpoint=featureU.point;
tmp=pointCloud(vertex);
figure;
pcshow(tmp);hold on;
for i=1:size(rootpoint,1)
    plot3([point1(i,1),point2(i,1)],[point1(i,2),point2(i,2)],[point1(i,3),point2(i,3)]);
end
scatter3(rootpoint(:,1),rootpoint(:,2),rootpoint(:,3),'r*');
scatter3(refpoint(:,1),refpoint(:,2),refpoint(:,3),'r*');



fid=fopen([path,'\','root.txt'],'w');
for i=1:size(rootpoint,1)
    fprintf(fid,'%f %f %f\n',rootpoint(i,1),rootpoint(i,2),rootpoint(i,3));
    
    fprintf(fid,'%f %f %f\n',rootnormal(i,1),rootnormal(i,2),rootnormal(i,3));
end


% projectionpoint=[featureL.maxYpoint(7,:);featureL.minYpoint(14:-1:8,:);featureL.minYpoint(1:7,:)]*Rs;
% dy=zeros([size(projectionpoint,1),1]);
% for i=1:size(projectionpoint,1)
%     [projectionpoint(i,2),projectionpoint(i,1),dy(i)]=get_nearest_point( [projectionpoint(i,2),projectionpoint(i,1)],curve2);
% end
rootpoints=zeros(size(Lroot,1),3);
rootnormal=zeros(size(Lroot,1),3);
for i=1:size(Uroot,1)
%binary search
left=1;
right=size(pixel_point.x,1);

while left<right-1
    mid=floor((left+right)/2);
    if( Lroot(i,1)==pixel_point.x(mid))
        left=mid;
        break;
    elseif(Lroot(i,1)<pixel_point.x(mid))
         right=mid-1;
    else
       left=mid;
    end
end
    rootpoints(i,1:2)=(projectionpoint(left+1,1:2)-projectionpoint(left,1:2))*(Lroot(i,1)-pixel_point.x(left))/(pixel_point.x(left+1)-pixel_point.x(left))+projectionpoint(left,1:2);
    [rootpoints(i,2),rootpoints(i,1),rootnormal(i,1)]=get_nearest_point( [rootpoints(i,2),rootpoints(i,1)],curve2);
    rootpoints(i,3)=size(paranoimg,1)-Lroot(i,2)-(max(L(:,2))-size(BB,1))+lz;
    rootpoints(i,1)=rootpoints(i,1)-xoffset;
    rootnormal(i,1)=-1/rootnormal(i,1);
    rootnormal(i,2)=1;
    rootnormal(i,3)=0;
end
figure;
scatter(projectionpoint(:,2),projectionpoint(:,1),'r*');hold on
scatter(rootpoints(:,2),rootpoints(:,1),'b*');
plot(curve2,'m');

% vertex=[];
% for i=1:7
%     vertex=[vertex;Mesh.LL{i};Mesh.LR{i}];
% end
% tmp=pointCloud(vertex);
% refpoint=featureL.point*Ri;
% figure;
% pcshow(tmp);hold on;
% scatter3(rootpoints(:,1),rootpoints(:,2),rootpoints(:,3),'r*');
% scatter3(refpoint(:,1),refpoint(:,2),refpoint(:,3),'r*');
% %验证 rootpoint跟特征点差不多在一起，

for i=1:size(rootnormal,1)
 rootnormal(i,:)=rootnormal(i,:)/norm(rootnormal(i,:),2);
end
rootpoint=rootpoints*inv(Ri);
constc=10;
point1=rootpoint-constc*rootnormal;
point2=constc*rootnormal+rootpoint;
vertex=[];
for i=1:7
    vertex=[vertex;LL{i};LR{i}];
end
refpoint=featureU.point;
tmp=pointCloud(vertex);
figure;
pcshow(tmp);hold on;
for i=1:size(rootpoint,1)
    plot3([point1(i,1),point2(i,1)],[point1(i,2),point2(i,2)],[point1(i,3),point2(i,3)]);
end
scatter3(rootpoint(:,1),rootpoint(:,2),rootpoint(:,3),'r*');

for i=1:size(rootpoint,1)
    fprintf(fid,'%f %f %f\n',rootpoint(i,1),rootpoint(i,2),rootpoint(i,3));
    
    fprintf(fid,'%f %f %f\n',rootnormal(i,1),rootnormal(i,2),rootnormal(i,3));
end
fclose(fid);