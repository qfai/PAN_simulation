%% U
vertex=[];
for i=1:7
    vertex=[vertex;Mesh.UL{i};Mesh.UR{i}];
end
tmp=pointCloud(vertex);

scalez=1;
ZLimits=floor((tmp.ZLimits(2)-tmp.ZLimits(1))*scalez)+1;
XLimits=floor((tmp.XLimits(2)-tmp.XLimits(1))*scalez)+1;
YLimits=floor((tmp.YLimits(2)-tmp.YLimits(1))*scalez)+1;
slices=zeros(XLimits,YLimits,ZLimits);
for i=1:size(vertex,1)
    slices(floor((vertex(i,1)-tmp.XLimits(1))*scalez+1),floor((vertex(i,2)-tmp.YLimits(1))*scalez+1),floor((vertex(i,3)-tmp.ZLimits(1))*scalez+1))=1;
end

% %mark point///////////////
markpoint=featureU.point*Rs;
%markpoint=floor(markpoint-repmat([tmp.XLimits(1),tmp.YLimits(1),tmp.ZLimits(1)],[size(markpoint,1),1]))+repmat([1,1,1],[size(markpoint,1),1]);
% for i=1:size(markpoint,1)
%     
%  slices(floor((markpoint(i,1)-tmp.XLimits(1))*scalez+1),floor((markpoint(i,2)-tmp.YLimits(1))*scalez+1),floor((markpoint(i,3)-tmp.ZLimits(1)+1.001)*scalez))=255;
% end

pop=[featureL.minYpoint;featureL.maxYpoint;featureU.minYpoint;featureU.maxYpoint]*Rs;
cdata=pop(:,1);
pop=pop(:,2);

tmpscript;
 markedu=marked;
% 
 BB=(generatedimg);
figure;
imshow(flip(BB));

 hold on ;
 scatter(markedu(:,1),size(BB,1)-markedu(:,2),'r*');hold off
 
index=find(BB>1);
umarked(:,1)=markedu(:,1)+pixel_point.x(1);
umarked(:,2)=markedu(:,2)+min(U(:,2));
Upoints=zeros(size(index,1),2);
%Upoints(:,2)=floor(mod(index,size(BB,1)))+ Ts(3)-max(markedpoint(:,2));
Upoints(:,2)=floor(mod(index,size(BB,1)))+min(U(:,2));%-min(marked(:,2));%+size(paranoimg,1)-max(U(:,2));
Upoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);