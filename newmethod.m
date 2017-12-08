%new method

%get all objs
tooth_path='D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\';
mesh.UL={};
mesh.UR={};
mesh.LL={};
mesh.LR={};
for i=1:7
    tmpname=[tooth_path,'U\UL',num2str(i),'.obj'];
    if(exist(tmpname,'file'))
    tmp=readObj(tmpname);
    if(size(mesh.UL)==0)
        mesh.UL={tmp.v};
    else
        mesh.UL=[mesh.UL,tmp.v];
    end
    end
    tmpname=[tooth_path,'U\UR',num2str(i),'.obj'];
    if(exist(tmpname,'file'))
    tmp=readObj(tmpname);
    if(size(mesh.UR)==0)
        mesh.UR={tmp.v};
    else
        mesh.UR=[mesh.UR,tmp.v];
    end
    end
    tmpname=[tooth_path,'L\LL',num2str(i),'.obj'];
    if(exist(tmpname,'file'))
    tmp=readObj(tmpname);
    if(size(mesh.LL)==0)
        mesh.LL={tmp.v};
    else
        mesh.LL=[mesh.LL,tmp.v];
    end
    end
    tmpname=[tooth_path,'L\LR',num2str(i),'.obj'];
    if(exist(tmpname,'file'))
    tmp=readObj(tmpname);
    if(size(mesh.LR)==0)
        mesh.LR={tmp.v};
    else
        mesh.LR=[mesh.LR,tmp.v];
    end
    end
end

%get all local axis
axesU=textscan('U.axes');

%get featurepoint
paranoimg=imread('sx.jpg');
load('sunxia_pan_point.mat');
U(:,2)=repmat(size(paranoimg,1),[size(U,1),1])-U(:,2);
L(:,2)=repmat(size(paranoimg,1),[size(L,1),1])-L(:,2);
meshfea=textread('sunxia.fea');
meshfea=meshfea(:,1:3);
featureL.minYpoint=[];
featureL.maxYpoint=[];
featureL.point=[];
count=1;
for i=1:7
    if(i<=5)
        featureL.point=[featureL.point;meshfea(count,:)];
        featureL.minYpoint=[featureL.minYpoint;meshfea(count+1,:)];
        featureL.maxYpoint=[featureL.maxYpoint;meshfea(count+2,:)];
        count=count+3;
    else
        featureL.point=[featureL.point;meshfea(count,:);meshfea(count+1,:)];
        featureL.minYpoint=[featureL.minYpoint;meshfea(count+2,:)];
        featureL.maxYpoint=[featureL.maxYpoint;meshfea(count+3,:)];
        count=count+4;
    end
end
for i=1:7
    if(i<=5)
        featureL.point=[featureL.point;meshfea(count,:)];
        featureL.minYpoint=[featureL.minYpoint;meshfea(count+1,:)];
        featureL.maxYpoint=[featureL.maxYpoint;meshfea(count+2,:)];
        count=count+3;
    else
        featureL.point=[featureL.point;meshfea(count,:);meshfea(count+1,:)];
        featureL.minYpoint=[featureL.minYpoint;meshfea(count+2,:)];
        featureL.maxYpoint=[featureL.maxYpoint;meshfea(count+3,:)];
        count=count+4;
    end
end
featureU.minYpoint=[];
featureU.maxYpoint=[];
featureU.point=[];
for i=1:7
    if(i<=5)
        featureU.point=[featureU.point;meshfea(count,:)];
        featureU.minYpoint=[featureU.minYpoint;meshfea(count+1,:)];
        featureU.maxYpoint=[featureU.maxYpoint;meshfea(count+2,:)];
        count=count+3;
    else
        featureU.point=[featureU.point;meshfea(count,:);meshfea(count+1,:)];
        featureU.minYpoint=[featureU.minYpoint;meshfea(count+2,:)];
        featureU.maxYpoint=[featureU.maxYpoint;meshfea(count+3,:)];
        count=count+4;
    end
end
for i=1:7
    if(i<=5)
        featureU.point=[featureU.point;meshfea(count,:)];
        featureU.minYpoint=[featureU.minYpoint;meshfea(count+1,:)];
        featureU.maxYpoint=[featureU.maxYpoint;meshfea(count+2,:)];
        count=count+3;
    else
        featureU.point=[featureU.point;meshfea(count,:);meshfea(count+1,:)];
        featureU.minYpoint=[featureU.minYpoint;meshfea(count+2,:)];
        featureU.maxYpoint=[featureU.maxYpoint;meshfea(count+3,:)];
        count=count+4;
    end
end
%translation well
%assume UL1 is origin

tmp=[];
  scale=max(abs((U(2,:)-U(1,:))./(featureU.point(2,2:3)-featureU.point(1,2:3))))
  
 feature=featureU.point;
 for i=1:5
    [mesh.UL{i},center]=scale_mesh(mesh.UL{i},[scale,scale,scale]);
    feature(i,:)=(feature(i,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.UL{i},center]=scale_mesh(mesh.UL{i},[scale,scale,scale]);
    feature((i-6)*2+6,:)=(feature((i-6)*2+6,:)-center).*[scale,scale,scale]+center;
     feature((i-6)*2+7,:)=(feature((i-6)*2+7,:)-center).*[scale,scale,scale]+center;
 end

 for i=1:5
    [mesh.UR{i},center]=scale_mesh(mesh.UR{i},[scale,scale,scale]);
    feature(i+9,:)=(feature(i+9,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.UR{i},center]=scale_mesh(mesh.UR{i},[scale,scale,scale]);
    feature((i-6)*2+6+9,:)=(feature((i-6)*2+6+9,:)-center).*[scale,scale,scale]+center;
     feature((i-6)*2+7+9,:)=(feature((i-6)*2+7+9,:)-center).*[scale,scale,scale]+center;
end
 
 
tmp=[];
for i=1:18
   
   % pixel_dis=(U(i,:)-U(1,:))*0.3;
    tmp=[tmp,(U(i,:)-( feature(i,2:3)))'];
end

tmp(:,6)=(tmp(:,6)+tmp(:,7))/2;
tmp(:,8)=(tmp(:,8)+tmp(:,9))/2;
tmp(:,15)=(tmp(:,15)+tmp(:,16))/2;
tmp(:,17)=(tmp(:,18)+tmp(:,17))/2;

translation.U=[tmp(:,1:6),tmp(:,8),tmp(:,10:15),tmp(:,17)];

%% L
 feature=featureL.point;
 for i=1:5
    [mesh.LL{i},center]=scale_mesh(mesh.LL{i},[scale,scale,scale]);
    feature(i,:)=(feature(i,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.LL{i},center]=scale_mesh(mesh.LL{i},[scale,scale,scale]);
    feature((i-6)*2+6,:)=(feature((i-6)*2+6,:)-center).*[scale,scale,scale]+center;
     feature((i-6)*2+7,:)=(feature((i-6)*2+7,:)-center).*[scale,scale,scale]+center;
 end

 for i=1:5
    [mesh.LR{i},center]=scale_mesh(mesh.LR{i},[scale,scale,scale]);
    feature(i+9,:)=(feature(i+9,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.LR{i},center]=scale_mesh(mesh.LR{i},[scale,scale,scale]);
    feature((i-6)*2+6+9,:)=(feature((i-6)*2+6+9,:)-center).*[scale,scale,scale]+center;
     feature((i-6)*2+7+9,:)=(feature((i-6)*2+7+9,:)-center).*[scale,scale,scale]+center;
end
 
 
tmp=[];
for i=1:18
   
   % pixel_dis=(U(i,:)-U(1,:))*0.3;
    tmp=[tmp,(L(i,:)-( feature(i,2:3)))'];
end

tmp(:,6)=(tmp(:,6)+tmp(:,7))/2;
tmp(:,8)=(tmp(:,8)+tmp(:,9))/2;
tmp(:,15)=(tmp(:,15)+tmp(:,16))/2;
tmp(:,17)=(tmp(:,18)+tmp(:,17))/2;

translation.L=[tmp(:,1:6),tmp(:,8),tmp(:,10:15),tmp(:,17)];




for i=1:7
    mesh.UL{i}=mesh.UL{i}+repmat([0,translation.U(1,i),0],[size(mesh.UL{i},1),1]);
      mesh.UL{i}=mesh.UL{i}+repmat([0,0,translation.U(2,i)],[size(mesh.UL{i},1),1]);
end
for i=1:7
    mesh.UR{i}=mesh.UR{i}+repmat([0,translation.U(1,i+7),0],[size(mesh.UR{i},1),1]);
      mesh.UR{i}=mesh.UR{i}+repmat([0,0,translation.U(2,i+7)],[size(mesh.UR{i},1),1]);
end
for i=1:7
    mesh.LL{i}=mesh.LL{i}+repmat([0,translation.L(1,i),0],[size(mesh.LL{i},1),1]);
      mesh.LL{i}=mesh.LL{i}+repmat([0,0,translation.L(2,i)],[size(mesh.LL{i},1),1]);
end
for i=1:7
    mesh.LR{i}=mesh.LR{i}+repmat([0,translation.L(1,i+7),0],[size(mesh.LR{i},1),1]);
      mesh.LR{i}=mesh.LR{i}+repmat([0,0,translation.L(2,i+7)],[size(mesh.LR{i},1),1]);
end

figure;
hold on;
for i=1:7
m=mesh.UL{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
m=mesh.UR{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
m=mesh.LL{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
m=mesh.LR{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
end
imshow(paranoimg);
alpha(0.5);
title('before rotation');
hold off 

for i=1:7

 str=['UL',num2str(i)];
 index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.UL{i};
    mesh.UL{i}=rotate_mesh(m,axesU(index+2,:),theta);
   %mesh.UL{i}=rotate_mesh(m,cross(xaxe,[1,0,0]),theta)
   str=['UR',num2str(i)];
    index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.UR{i};
    mesh.UR{i}=rotate_mesh(m,axesU(index+2,:),theta);
   
end

figure;
hold on;
for i=1:7
m=mesh.UL{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
m=mesh.UR{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
m=mesh.LL{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
m=mesh.LR{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
end
imshow(paranoimg);
alpha(0.5);
title('after rotation');
hold off 