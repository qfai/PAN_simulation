%new method
function []=newmethod_one_point(tooth_path,pan_point_file,paraimgname,feafile,Uaxes,Laxes)
%get all objs

mesh.UL={};
mesh.UR={};
mesh.LL={};
mesh.LR={};
% load('sxmesh.mat');
% mesh.UL=UL;
% mesh.UR=UR;
% mesh.LL=LL;
% mesh.LR=LR;
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
axesU=textread(Uaxes);
axesL=textread(Laxes);

%get featurepoint
paranoimg=imread(paraimgname);
load(pan_point_file);
% U(:,2)=repmat(size(paranoimg,1),[size(U,1),1])-U(:,2);
% L(:,2)=repmat(size(paranoimg,1),[size(L,1),1])-L(:,2);
meshfea=textread(feafile);
meshfea=meshfea(:,1:3);
featureL.minYpoint=[];
featureL.maxYpoint=[];
featureL.point=[];
count=1;
for i=1:7

        featureL.point=[featureL.point;meshfea(count,:)];
        featureL.minYpoint=[featureL.minYpoint;meshfea(count+1,:)];
        featureL.maxYpoint=[featureL.maxYpoint;meshfea(count+2,:)];
        count=count+3;
end
for i=1:7
    
        featureL.point=[featureL.point;meshfea(count,:)];
        featureL.minYpoint=[featureL.minYpoint;meshfea(count+1,:)];
        featureL.maxYpoint=[featureL.maxYpoint;meshfea(count+2,:)];
        count=count+3;
end
featureU.minYpoint=[];
featureU.maxYpoint=[];
featureU.point=[];
for i=1:7
   
        featureU.point=[featureU.point;meshfea(count,:)];
        featureU.minYpoint=[featureU.minYpoint;meshfea(count+1,:)];
        featureU.maxYpoint=[featureU.maxYpoint;meshfea(count+2,:)];
        count=count+3;
end
for i=1:7
    
        featureU.point=[featureU.point;meshfea(count,:)];
        featureU.minYpoint=[featureU.minYpoint;meshfea(count+1,:)];
        featureU.maxYpoint=[featureU.maxYpoint;meshfea(count+2,:)];
        count=count+3;
end
%translation well
%assume UL1 is origin
tmp=[];

  scale=max(abs((U(2,:)-U(1,:))./(featureU.point(2,2:3)-featureU.point(1,2:3))))
   featureu=featureU.point;
    featurel=featureL.point;
for i=1:7

 str=['UL',num2str(i)];
 index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.UL{i};
    [mesh.UL{i},center]=rotate_mesh(m,axesU(index+2,:),theta);
     featureu(i,:)=rotate_mesh(featureu(i,:),axesU(index+2,:),theta,center);
   %mesh.UL{i}=rotate_mesh(m,cross(xaxe,[1,0,0]),theta)
   str=['UR',num2str(i)];
    index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.UR{i};
    [mesh.UR{i},center]=rotate_mesh(m,axesU(index+2,:),theta);
     featureu(i+7,:)=rotate_mesh(featureu(i+7,:),axesU(index+2,:),theta,center);
    
    str=['LR',num2str(i)];
    index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.LR{i};
    [mesh.LR{i},center]=rotate_mesh(m,axesU(index+2,:),theta);
     featurel(i+7,:)=rotate_mesh(featurel(i+7,:),axesU(index+2,:),theta,center);
    
     str=['LL',num2str(i)];
    index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.LL{i};
    [mesh.LL{i},center]=rotate_mesh(m,axesU(index+2,:),theta);
     featurel(i,:)=rotate_mesh(featurel(i,:),axesU(index+2,:),theta,center);
end

 for i=1:7
    [mesh.UL{i},center]=scale_mesh(mesh.UL{i},[scale,scale,scale]);
    featureu(i,:)=(featureu(i,:)-center).*[scale,scale,scale]+center;
 end
 for i=1:7
    [mesh.UR{i},center]=scale_mesh(mesh.UR{i},[scale,scale,scale]);
    featureu(i+7,:)=(featureu(i+7,:)-center).*[scale,scale,scale]+center;
 end

tmp=[];
for i=1:14
   
   % pixel_dis=(U(i,:)-U(1,:))*0.3;
    tmp=[tmp,(U(i,:)-( featureu(i,2:3)))'];
end


translation.U=tmp;

%% L
 for i=1:7
    [mesh.LL{i},center]=scale_mesh(mesh.LL{i},[scale,scale,scale]);
    featurel(i,:)=(featurel(i,:)-center).*[scale,scale,scale]+center;
 end
 
 for i=1:7
    [mesh.LR{i},center]=scale_mesh(mesh.LR{i},[scale,scale,scale]);
    featurel(i+7,:)=(featurel(i+7,:)-center).*[scale,scale,scale]+center;
 end
 
 
tmp=[];
for i=1:14
   
   % pixel_dis=(U(i,:)-U(1,:))*0.3;
    tmp=[tmp,(L(i,:)-( featurel(i,2:3)))'];
end



translation.L=tmp;



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
title('after rotation');
hold off 

end