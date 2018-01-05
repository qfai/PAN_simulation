% i=6;
% points=MaskToPoints(roiMask);
% [mm,n]=size(roiMask);
% str=['LL',num2str(i)];
% points(:,2)=mm-points(:,2);
% index=transfor_axes(str);
% zaxe=axesL(index+2,:);
% axe=cross(zaxe,[1,0,0]);
% m=mesh.LL{i};
% origin=[sum(m(:,2))/size(m,1),sum(m(:,3))/size(m,1)];
% 
% m=m-repmat([0,translation.L(1,i),0],[size(mesh.LL{i},1),1]);
% m=m-repmat([0,0,translation.L(2,i)],[size(mesh.LL{i},1),1]);
% center=sum(m)/size(m,1);
% points=points-repmat(origin,[size(points,1),1]);
% dpoint=zeros(size(points,1),3);
% dpoint(:,1)=points(:,1).*repmat(axe(1),[size(points,1),1])+points(:,2).*repmat(zaxe(1),[size(points,1),1]);
% dpoint(:,2)=points(:,1).*repmat(axe(2),[size(points,1),1])+points(:,2).*repmat(zaxe(2),[size(points,1),1]);
% dpoint(:,3)=points(:,1).*repmat(axe(3),[size(points,1),1])+points(:,2).*repmat(zaxe(3),[size(points,1),1]);
% 
% %%%%%%%%%LL6
% xaxe=axesL(index,:);
% theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
%     
% axes=zaxe/norm(zaxe,2);
% u=axes(1);
% v=axes(2);
% w=axes(3);
% dpoint=dpoint/([u^2+(1-u^2)*cos(theta),u*v*(1-cos(theta))-w*sin(theta),u*w*(1-cos(theta))+v*sin(theta);
%     u*v*(1-cos(theta))+w*sin(theta),v^2+(1-v^2)*cos(theta), v*w*(1-cos(theta))-u*sin(theta);
%     u*w*(1-cos(theta))-v*sin(theta),v*w*(1-cos(theta))+u*sin(theta),w^2+(1-w^2)*cos(theta)]);
% 
% dpoint=dpoint./repmat(scale,[size(dpoint)]);
% dpoint=dpoint+repmat(center,[size(dpoint,1),1]);
% 
% 
% load('../tooth2.mat');

i=3;
points=MaskToPoints(roiMask);
[mm,n]=size(roiMask);
str=['UL',num2str(i)];
points(:,2)=mm-points(:,2);
index=transfor_axes(str);
zaxe=axesU(index+2,:);
zaxe=-1*zaxe;
axe=cross(zaxe,[1,0,0]);
m=mesh.UL{i};



imshow(paranoimg);hold on
scatter(points(:,1),mm-points(:,2));
scatter(origin(1),mm-origin(2));

m=m-repmat([0,translation.L(1,i),0],[size(m,1),1]);
m=m-repmat([0,0,translation.L(2,i)],[size(m,1),1]);
origin=[sum(m(:,2))/size(m,1),sum(m(:,3))/size(m,1)];
points=points-repmat(translation.L(:,i)',[size(points,1),1]);
points=points-repmat(origin,[size(points,1),1]);
dpoint=zeros(size(points,1),3);
dpoint(:,1)=points(:,1).*repmat(axe(1),[size(points,1),1])+points(:,2).*repmat(zaxe(1),[size(points,1),1]);
dpoint(:,2)=points(:,1).*repmat(axe(2),[size(points,1),1])+points(:,2).*repmat(zaxe(2),[size(points,1),1]);
dpoint(:,3)=points(:,1).*repmat(axe(3),[size(points,1),1])+points(:,2).*repmat(zaxe(3),[size(points,1),1]);

%%%%%%%%%LL6
xaxe=axesL(index,:);
theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    
axes=zaxe/norm(zaxe,2);
u=axes(1);
v=axes(2);
w=axes(3);
dpoint=dpoint/([u^2+(1-u^2)*cos(theta),u*v*(1-cos(theta))-w*sin(theta),u*w*(1-cos(theta))+v*sin(theta);
    u*v*(1-cos(theta))+w*sin(theta),v^2+(1-v^2)*cos(theta), v*w*(1-cos(theta))-u*sin(theta);
    u*w*(1-cos(theta))-v*sin(theta),v*w*(1-cos(theta))+u*sin(theta),w^2+(1-w^2)*cos(theta)]);

dpoint=dpoint./repmat(scale,[size(dpoint)]);
dpoint=dpoint+repmat(center,[size(dpoint,1),1]);

tmpname=[tooth_path,'U\UL',num2str(i),'.obj'];
if(exist(tmpname,'file'))
    tmp=readObj(tmpname);
end
orimesh=tmp.v;
pcshow(pointCloud(orimesh));
hold on
pcshow(pointCloud(dpoint));


filename='tooth2.xyz';
ff=fopen(filename,'a+');
for i=1:size(dpoint,1)  b       
    fprintf(ff,'%d\t%d\t%d\n',dpoint(i,1),dpoint(i,2),dpoint(i,3));
end
fclose(ff);
