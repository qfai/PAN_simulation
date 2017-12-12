%trace a life of a point
%mesh.LL=LL;
tooth=LL{7};
featurel=featureL.point;

index=transfor_axes('LL7');
    xaxe=axesL(index,:);
    theta=acos([xaxe(1:2),0]*[1,0,0]'/norm([xaxe(1:2),0],2));
    % arbitrary rotation.

    [tooth,center]=rotate_mesh(tooth,axesU(index+2,:),theta);
     featurel(8,:)=rotate_mesh(featurel(8,:),axesU(index+2,:),theta,center);
     featurel(9,:)=rotate_mesh(featurel(9,:),axesU(index+2,:),theta,center);

figure
pcshow(pointCloud(tooth));hold on
 scatter3(featurel(8:9,1),featurel(8:9,2),featurel(8:9,3),'r');

  scale=max(abs((U(2,:)-U(1,:))./(featureU.point(2,2:3)-featureU.point(1,2:3))))
  [tooth,center]=scale_mesh(tooth,[scale,scale,scale]);
    featurel(8,:)=(featurel(8,:)-center).*[scale,scale,scale]+center;
     featurel(9,:)=(featurel(9,:)-center).*[scale,scale,scale]+center;
     
     translations=(L(8,:)-featurel(8,2:3)+L(9,:)-featurel(9,2:3))/2;
    tooth=tooth+repmat([0,translations(1),0],[size(tooth,1),1]);
     tooth=tooth+repmat([0,0,translations(2)],[size(tooth,1),1]);
     
     figure;
     scatter(tooth(:,2),repmat(size(paranoimg,1),[size(tooth,1),1])-tooth(:,3));
     hold on;
     imshow(paranoimg);
alpha(0.5);
