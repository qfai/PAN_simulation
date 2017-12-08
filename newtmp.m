%load('sxmesh.mat');
mesh.UL=UL;
mesh.UR=UR;
mesh.LL=LL;
mesh.LR=LR;
tmp=[];
  scale=max(abs((U(2,:)-U(1,:))./(featureU.point(2,2:3)-featureU.point(1,2:3))))
  
 featureu=featureU.point;
 for i=1:5
    [mesh.UL{i},center]=scale_mesh(mesh.UL{i},[scale,scale,scale]);
    featureu(i,:)=(featureu(i,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.UL{i},center]=scale_mesh(mesh.UL{i},[scale,scale,scale]);
    featureu((i-6)*2+6,:)=(featureu((i-6)*2+6,:)-center).*[scale,scale,scale]+center;
     featureu((i-6)*2+7,:)=(featureu((i-6)*2+7,:)-center).*[scale,scale,scale]+center;
 end

 for i=1:5
    [mesh.UR{i},center]=scale_mesh(mesh.UR{i},[scale,scale,scale]);
    featureu(i+9,:)=(featureu(i+9,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.UR{i},center]=scale_mesh(mesh.UR{i},[scale,scale,scale]);
    featureu((i-6)*2+6+9,:)=(featureu((i-6)*2+6+9,:)-center).*[scale,scale,scale]+center;
     featureu((i-6)*2+7+9,:)=(featureu((i-6)*2+7+9,:)-center).*[scale,scale,scale]+center;
end
 
 
tmp=[];
for i=1:18
   
   % pixel_dis=(U(i,:)-U(1,:))*0.3;
    tmp=[tmp,(U(i,:)-( featureu(i,2:3)))'];
end

tmp(:,6)=(tmp(:,6)+tmp(:,7))/2;
tmp(:,8)=(tmp(:,8)+tmp(:,9))/2;
tmp(:,15)=(tmp(:,15)+tmp(:,16))/2;
tmp(:,17)=(tmp(:,18)+tmp(:,17))/2;

translation.U=[tmp(:,1:6),tmp(:,8),tmp(:,10:15),tmp(:,17)];

%% L
 featurel=featureL.point;
 for i=1:5
    [mesh.LL{i},center]=scale_mesh(mesh.LL{i},[scale,scale,scale]);
    featurel(i,:)=(featurel(i,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.LL{i},center]=scale_mesh(mesh.LL{i},[scale,scale,scale]);
    featurel((i-6)*2+6,:)=(featurel((i-6)*2+6,:)-center).*[scale,scale,scale]+center;
     featurel((i-6)*2+7,:)=(featurel((i-6)*2+7,:)-center).*[scale,scale,scale]+center;
 end

 for i=1:5
    [mesh.LR{i},center]=scale_mesh(mesh.LR{i},[scale,scale,scale]);
    featurel(i+9,:)=(featurel(i+9,:)-center).*[scale,scale,scale]+center;
 end
 for i=6:7
    [mesh.LR{i},center]=scale_mesh(mesh.LR{i},[scale,scale,scale]);
    featurel((i-6)*2+6+9,:)=(featurel((i-6)*2+6+9,:)-center).*[scale,scale,scale]+center;
     featurel((i-6)*2+7+9,:)=(featurel((i-6)*2+7+9,:)-center).*[scale,scale,scale]+center;
end
 
 
tmp=[];
for i=1:18
   
   % pixel_dis=(U(i,:)-U(1,:))*0.3;
    tmp=[tmp,(L(i,:)-( featurel(i,2:3)))'];
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
    [mesh.UR{i},center]=rotate_mesh(m,axesU(index+2,:),theta);
    str=['LR',num2str(i)];
    index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.LR{i};
    [mesh.LR{i},center]=rotate_mesh(m,axesU(index+2,:),theta);
     str=['LL',num2str(i)];
    index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.LL{i};
    [mesh.LL{i},center]=rotate_mesh(m,axesU(index+2,:),theta);
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