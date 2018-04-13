%% L

vertex=[];
for i=1:7
    vertex=[vertex;Mesh.LL{i};Mesh.LR{i}];
end
tmp=pointCloud(vertex);
scalez=1;

 ZLimits=floor((tmp.ZLimits(2)-tmp.ZLimits(1))*scalez)+1;
% XLimits=floor((tmp.XLimits(2)-tmp.XLimits(1))*scalez)+1;
% YLimits=floor((tmp.YLimits(2)-tmp.YLimits(1))*scalez)+1;
slices=zeros(size(slices,1),size(slices,2),ZLimits);

 featureU.minYpoint(14,2)=featureU.maxYpoint(13,2);
 projectionpoint=[featureU.maxYpoint(14,:);featureU.minYpoint(14:-1:8,:);featureU.minYpoint(1:7,:)]*Rs;
 dy=0;
i=1;
[projectionpoint(i,2),projectionpoint(i,1),dy]=get_nearest_point( [projectionpoint(i,2),projectionpoint(i,1)],curve2);
dy=abs(dy);
xoffset=-U(18,1)+L(18,1)*dy/sqrt(dy*dy+1);
for i=1:size(vertex,1)
    if(floor((vertex(i,1)-tmp.XLimits(1)+xoffset)*scalez+1)>0&&floor((vertex(i,1)-tmp.XLimits(1)+xoffset)*scalez+1)<=size(slices,1))
        slices(floor((vertex(i,1)-tmp.XLimits(1)+xoffset)*scalez+1),floor((vertex(i,2)-tmp.YLimits(1))*scalez+1),floor((vertex(i,3)-tmp.ZLimits(1))*scalez+1))=1;
    end
end



% 
 markpoint=featureL.point*Ri;
 %markpoint=floor(markpoint-repmat([tmp.XLimits(1),tmp.YLimits(1),tmp.ZLimits(1)],[size(markpoint,1),1]))+repmat([1,1,1],[size(markpoint,1),1]);
 markpoint(:,1)= markpoint(:,1)+xoffset;
% for i=1:size(markpoint,1)
%     
%  slices(floor((markpoint(i,1)-tmp.XLimits(1)+xoffset)*scalez+1),floor((markpoint(i,2)-tmp.YLimits(1))*scalez+1),floor((markpoint(i,3)-tmpl.ZLimits(1))*scalez+1))=255;
% end



tmpscript;


 BB=(generatedimg);
% 
% markindex=find(BB>=255);
%  lmarked=zeros(size(markindex,1),2);
%  lmarked(:,1)=floor(markindex(:)/size(BB,1));
%  lmarked(:,2)=markindex-lmarked(:,1)*size(BB,1);
markedl=marked;
figure;
imshow(flip(BB));
 hold on ;scatter(markedl(:,1),size(BB,1)-markedl(:,2),'r*');hold off
 lmarked(:,1)=markedl(:,1)+pixel_point.x(1);
 lmarked(:,2)=markedl(:,2)+max(L(:,2))-size(BB,1);
index=find(BB>1);
Lpoints=zeros(size(index,1),2);
%Upoints(:,2)=floor(mod(index,size(BB,1)))+ Ts(3)-max(markedpoint(:,2));
Lpoints(:,2)=floor(mod(index,size(BB,1)))+max(L(:,2))-size(BB,1);%-max(lmarked(:,2));%+size(paranoimg,1)-min(L(:,2));
Lpoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);

