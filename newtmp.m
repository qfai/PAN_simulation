mesh.UL={};
mesh.UR={};
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
end

tmp=[];
  scale=abs((U(2,:)-U(1,:))./(featureU.point(2,2:3)-featureU.point(1,2:3)))
 
 for i=1:7
    mesh.UL{i}=scale_mesh(mesh.UL{i},[1,scale(1),scale(2)]);
end

 
for i=1:18 
   
   % pixel_dis=(U(i,:)-U(1,:))*0.3;
    tmp=[tmp,(U(i,:)-(featureU.point(i,2:3)))'];
end

tmp(:,6)=(tmp(:,6)+tmp(:,7))/2;
tmp(:,8)=(tmp(:,8)+tmp(:,9))/2;
tmp(:,15)=(tmp(:,15)+tmp(:,16))/2;
tmp(:,17)=(tmp(:,18)+tmp(:,17))/2;

%pixel_dis=(U(1,:)-featureU.point(1,2:3))*0.3;

translation.U=[tmp(:,1:6),tmp(:,8),tmp(:,10:15),tmp(:,17)];%+repmat(pixel_dis',[1,14]);



for i=1:7
    mesh.UL{i}=mesh.UL{i}+repmat([0,translation.U(1,i),0],[size(mesh.UL{i},1),1]);
      mesh.UL{i}=mesh.UL{i}+repmat([0,0,translation.U(2,i)],[size(mesh.UL{i},1),1]);
end
figure;
hold on;
for i=1:7
m=mesh.UL{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
end
imshow(paranoimg);
alpha(0.5);

for i=1:7
%     str=['UL',num2str(i)];
%     xaxe=axesU(transfor_axes(str),:);
%     theta=acos(xaxe*[1,0,0]'/norm(xaxe,2));
%     % arbitrary rotation.
%     m=mesh.UL{i};
%     m=[m;featureU.point(i,:).*[1,scale(1),scale(2)]];
%     m=rotate_mesh(m,cross(xaxe,[1,0,0]),theta);
%     transfored=m(size(m,1),:);
%     m=m(1:size(m,1)-1,:);
%     m(:,2:3)=m(:,2:3)+repmat((U(i,:)-transfored(2:3)),[size(m,1),1]);
%     mesh.UL{i}=m;
 str=['UL',num2str(i)];
 index=transfor_axes(str);
    xaxe=axesU(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.
    m=mesh.UL{i};
    mesh.UL{i}=rotate_mesh(m,axesU(index+2,:),theta);
end

figure;
hold on;
for i=1:7
m=mesh.UL{i};
scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
end
imshow(paranoimg);
alpha(0.5);
