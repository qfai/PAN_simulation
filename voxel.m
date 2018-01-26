%% test volization

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
scale=param(1);
a=param(2);%cos(alpha)
b=param(3);
c=param(4);
d=param(5);
Rs=scale*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
transed=pointU*Rs;
Ts=[0,U(1,1)-transed(1,2),U(1,2)-transed(1,3)];

figure;
imshow(paranoimg);hold on;
scatter(U(:,1),size(paranoimg,1)-U(:,2));

 transed=transed+repmat(Ts,[size(transed,1),1]);
 scatter(transed(:,2 ),size(paranoimg,1)-transed(:,3));


pointU=pointU*Rs;
B=U(:,2)-L(:,2);
fun = @regifun2;
% pointU=pointL;
% B=L(:,2)-repmat(L(1,2),[size(L,1),1]);
% fun = @regifun;
x0 = [10,1,0,1,0]; 
x = fsolve(fun,x0);
scale=param(1);
a=param(2);%cos(alpha)
b=param(3);
c=param(4);
d=param(5);
Ri=scale*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
transed=pointL*Ri;
Ti=[0,L(1,1)-transed(1,2),L(1,2)-transed(1,3)];

scatter(L(:,1),size(paranoimg,1)-L(:,2));

 transed=transed+repmat(Ti,[size(transed,1),1]);
 scatter(transed(:,2 ),size(paranoimg,1)-transed(:,3));


Mesh.LL={};
Mesh.LR={};
Mesh.UL={};
Mesh.UR={};
for i=1:7
    Mesh.LL{i}=LL{i}*Ri
    Mesh.UL{i}=UL{i}*Rs
    Mesh.LR{i}=LR{i}*Ri
    Mesh.UR{i}=UR{i}*Rs
end

vertex=[];
for i=1:7
    vertex=[vertex;Mesh.UL{i};Mesh.UR{i}];
end
tmp=pointCloud(vertex);
scalez=1;

[stlcoords] = READ_stl('D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\U.stl');
for i=1:size(stlcoords,1)
    stlcoords(i,:,:)=permute((permute(stlcoords(i,:,:),[3,2,1])*Rs),[3,2,1]);
end
[slices] = VOXELISE(floor(tmp.XLimits(2)-tmp.XLimits(1)+1),floor(tmp.YLimits(2)-tmp.YLimits(1)+1),floor(tmp.ZLimits(2)-tmp.ZLimits(1)+1),'D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\U.stl','xyz');
% 
% Ts = 1.0e+03 *[ 0    1.4506    0.7540];
% Ti=1.0e+03 *[0    1.4434    0.6285];


pop=[featureL.minYpoint*Ri;featureL.maxYpoint*Ri;featureU.minYpoint*Rs;featureU.maxYpoint*Rs];
cdata=pop(:,1);
pop=pop(:,2);
 fo = fitoptions('Method','NonlinearLeastSquares');
% fo.Normalize='on';
g = fittype('a*x^4+b*x^3+d*x+e','option',fo);
 [curve2,gof2] = fit(pop,cdata,g);
 figure;
 scatter(vertex(:,2),vertex(:,1));
hold on
plot(curve2,'m')

featureU.minYpoint(14,2)=featureU.maxYpoint(13,2);
projectionpoint=[featureU.maxYpoint(14,:);featureU.minYpoint]*Rs;
dy=zeros([size(projectionpoint,1),1]);
for i=1:size(projectionpoint,1)
    [projectionpoint(i,2),projectionpoint(i,1),dy(i)]=get_nearest_point( [projectionpoint(i,2),projectionpoint(i,1)],curve2);
end
scatter(projectionpoint(:,2),projectionpoint(:,1),'r*');


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


%slices=OUTPUTgrid;
 scalez=1;
tmpscript

BB=flipud(generatedimg);
Uimg=BB;
Umark=markedpoint;
imshow(BB)
%hold on ;scatter(markedpoint(:,1),size(Uimg,1)-markedpoint(:,2),'r*');hold off


index=find(BB>1);
Upoints=zeros(size(index,1),2);
Upoints(:,2)=floor(mod(index,size(BB,1)))+pixel_point.y(1)-size(BB,1)/4;
Upoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);



vertex=[];
for i=1:7
    vertex=[vertex;Mesh.LL{i};Mesh.LR{i}];
end
tmp=pointCloud(vertex);

[stlcoords] = READ_stl('D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\L.stl');
for i=1:size(stlcoords,1)
    stlcoords(i,:,:)=permute((permute(stlcoords(i,:,:),[3,2,1])*Rs+repmat(Ts,[3,1])),[3,2,1]);
end
[slices] = VOXELISE(floor(tmp.XLimits(2)-tmp.XLimits(1)+1),floor(tmp.YLimits(2)-tmp.YLimits(1)+1),floor(tmp.ZLimits(2)-tmp.ZLimits(1)+1),'D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\L.stl','xyz');


tmpscript

BB=flipud(generatedimg);
Limg=BB;
Lmark=markedpoint;
figure;
imshow(BB)
%hold on ;scatter(markedpoint(:,1),size(Limg,1)-markedpoint(:,2),'r*');hold off



index=find(BB>1);
Lpoints=zeros(size(index,1),2);
Lpoints(:,2)=floor(mod(index,size(BB,1)))+Ts(3)-size(BB,1)/4;
Lpoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);

 figure;
  scatter(Lpoints(:,1),Lpoints(:,2));hold on;
scatter(Upoints(:,1),Upoints(:,2));hold on;
f=imshow(paranoimg);set(f,'AlphaData',0.5);axis on
%  figure;imshow(paranoimg);axis on;hold on;
%   scatter(Lpoints(:,1),Lpoints(:,2));
% scatter(Upoints(:,1),Upoints(:,2));hold on;