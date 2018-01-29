%initial rigid transformation
load('sunxia_pan_point.mat');
load('sxmesh.mat');
paranoimg=imread('sx.jpg');
U(:,2)=repmat(size(paranoimg,1),[size(U,1),1])-U(:,2);
L(:,2)=repmat(size(paranoimg,1),[size(L,1),1])-L(:,2);
panU=U-repmat(U(1,:),[size(U,1),1]);

feafile='sunxia.fea';

meshfea=textread(feafile);
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

global pointU;
global pointL;
global B;
pointU=featureU.point;
pointL=featureL.point;
B=U(:,2)-repmat(U(1,2),[size(U,1),1]);
fun = @regifun;
x0 = [10,1,0,1,0]; 
x = fsolve(fun,x0);

param=x;
scale=param(1)
a=param(2);%cos(alpha)
b=param(3);
c=param(4);
d=param(5);
Rs=scale*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
transed=pointU*Rs;
Ts=[0,U(1,1)-transed(1,2),U(1,2)-transed(1,3)];

% pointU=featureL.point;
% B=L(:,2)-repmat(L(1,2),[size(L,1),1]);
% fun = @regifun;
pointU=pointU*Rs;
B=U(:,2)-L(:,2);
fun = @regifun2;
% pointU=pointL;
% B=L(:,2)-repmat(L(1,2),[size(L,1),1]);
% fun = @regifun;
x0 = [10,1,0,1,0]; 
x = fsolve(fun,x0);
scale=param(1)
a=param(2);%cos(alpha)
b=param(3);
c=param(4);
d=param(5);
Ri=scale*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
transed=pointL*Ri;
Ti=[0,L(1,1)-transed(1,2),L(1,2)-transed(1,3)];

% upoint=featureU.point-repmat(featureU.point(1,:),[size(featureU.point,1),1]);
% [Rs,Ts,Ri,Ti,SCALE]=RegisterbyIterTheta(featureU.point,U,featureL.point,L);
Mesh.LL={};
Mesh.LR={};
Mesh.UL={};
Mesh.UR={};
for i=1:7
    Mesh.LL{i}=LL{i}*Ri;
    Mesh.UL{i}=UL{i}*Rs;
    Mesh.LR{i}=LR{i}*Ri;
    Mesh.UR{i}=UR{i}*Rs;
end

% figure;
% hold on;
% for i=1:7
% m=Mesh.UL{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% m=Mesh.UR{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% m=Mesh.LL{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% m=Mesh.LR{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% end
% imshow(paranoimg);
% alpha(0.5);
% title('after rotation');
% hold off 


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

%mark point///////////////
markpoint=featureU.point*Rs;
for i=1:size(markpoint,1)
    
 slices(floor((markpoint(i,1)-tmp.XLimits(1))*scalez+1),floor((markpoint(i,2)-tmp.YLimits(1))*scalez+1),floor((markpoint(i,3)-tmp.ZLimits(1))*scalez+1))=255;
end

pop=[featureL.minYpoint;featureL.maxYpoint;featureU.minYpoint;featureU.maxYpoint]*Rs;
cdata=pop(:,1);
pop=pop(:,2);


% pop=[featureL.minYpoint(:,2);featureL.maxYpoint(:,2);featureU.minYpoint(:,2);featureU.maxYpoint(:,2)]*SCALE;
% cdata=[featureL.minYpoint(:,1);featureL.maxYpoint(:,1);featureU.minYpoint(:,1);featureU.maxYpoint(:,1)]*SCALE;
 fo = fitoptions('Method','NonlinearLeastSquares');
g = fittype('a*x^4+b*x^3+d*x+e','option',fo);
%g = fittype('a*x^2+b*x+c','option',fo);
 [curve2,gof2] = fit(pop,cdata,g);
 figure;
 scatter(vertex(:,2),vertex(:,1));
hold on
plot(curve2,'m')
 minx=min(pop);
 maxx=max(pop);
 sample_number=100;%floor(size(paranoimg,1)*4/3);
pixel_size=0.1;


pixel_point.x=1.0e+03 *[

    0.8275
    0.9575
    1.0815
    1.1575
    1.2315
    1.3115
    1.3815
    1.4595
    1.5395
    1.6095
    1.6935
    1.7755
    1.8595
    1.9835
    2.1255];
pixel_point.y=[  613.0000
  627.0000
  639.0000
  661.0000
  671.0000
  671.0000
  673.0000
  671.0000
  673.0000
  673.0000
  677.0000
  677.0000
  683.0000
  653.0000
  639.0000];




tmpscript;


BB=(generatedimg);
figure;
imshow(flip(BB));
markindex=find(BB>=255);
 markedu=zeros(size(markindex,1),2);
 markedu(:,1)=floor(markindex(:)/size(BB,1));
 markedu(:,2)=markindex-markedu(:,1)*size(BB,1);
 hold on ;scatter(markedu(:,1),size(BB,1)-markedu(:,2),'r*');hold off
 
index=find(BB>1);
Upoints=zeros(size(index,1),2);
%Upoints(:,2)=floor(mod(index,size(BB,1)))+ Ts(3)-max(markedpoint(:,2));
Upoints(:,2)=floor(mod(index,size(BB,1)))+min(U(:,2))-min(marked(:,2));
Upoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);






%% L

vertex=[];
for i=1:7
    vertex=[vertex;Mesh.LL{i};Mesh.LR{i}];
end
tmpl=pointCloud(vertex);
scalez=1;
 ZLimits=floor((tmpl.ZLimits(2)-tmpl.ZLimits(1))*scalez)+1;
% XLimits=floor((tmp.XLimits(2)-tmp.XLimits(1))*scalez)+1;
% YLimits=floor((tmp.YLimits(2)-tmp.YLimits(1))*scalez)+1;
slices=zeros(size(slices,1),size(slices,2),ZLimits);

 featureU.minYpoint(14,2)=featureU.maxYpoint(13,2);
 projectionpoint=[featureU.maxYpoint(14,:);featureU.minYpoint(14:-1:8,:);featureU.minYpoint(1:7,:)]*Rs;
 dy=0;
i=1;
[projectionpoint(i,2),projectionpoint(i,1),dy]=get_nearest_point( [projectionpoint(i,2),projectionpoint(i,1)],curve2);
xoffset=-U(18,1)+L(18,1)*dy/sqrt(dy*dy+1);
for i=1:size(vertex,1)
    slices(floor((vertex(i,1)-tmp.XLimits(1)+xoffset)*scalez+1),floor((vertex(i,2)-tmp.YLimits(1))*scalez+1),floor((vertex(i,3)-tmpl.ZLimits(1))*scalez+1))=1;
end




markpoint=featureL.point*Ri;
for i=1:size(markpoint,1)
    
 slices(floor((markpoint(i,1)-tmp.XLimits(1)+xoffset)*scalez+1),floor((markpoint(i,2)-tmp.YLimits(1))*scalez+1),floor((markpoint(i,3)-tmpl.ZLimits(1))*scalez+1))=255;
end



tmpscript;


BB=(generatedimg);

markindex=find(BB>=255);
 marked=zeros(size(markindex,1),2);
 marked(:,1)=floor(markindex(:)/size(BB,1));
 marked(:,2)=markindex-marked(:,1)*size(BB,1);
figure;
imshow(flip(BB));
 hold on ;scatter(marked(:,1),size(BB,1)-marked(:,2),'r*');hold off
 
index=find(BB>1);
Lpoints=zeros(size(index,1),2);
%Upoints(:,2)=floor(mod(index,size(BB,1)))+ Ts(3)-max(markedpoint(:,2));
Lpoints(:,2)=floor(mod(index,size(BB,1)))+max(L(:,2))-max(marked(:,2));
Lpoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);



 figure;
  scatter(Lpoints(:,1),size(paranoimg,1)-Lpoints(:,2));hold on;
scatter(Upoints(:,1),size(paranoimg,1)-Upoints(:,2));hold on;
scatter(marked(:,1)+1+pixel_point.x(1),size(paranoimg,1)-(marked(:,2)+max(L(:,2))-max(marked(:,2))),'r*');
scatter(U(:,1),size(paranoimg,1)-U(:,2),'b*');
scatter(L(:,1),size(paranoimg,1)-L(:,2),'b*');
f=imshow(paranoimg);set(f,'AlphaData',0.5);axis on
