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

% upoint=featureU.point-repmat(featureU.point(1,:),[size(featureU.point,1),1]);
% [Rs,Ts,Ri,Ti,SCALE]=RegisterbyIterTheta(featureU.point,U,featureL.point,L);
Mesh.LL={};
Mesh.LR={};
Mesh.UL={};
Mesh.UR={};
for i=1:7
    Mesh.LL{i}=LL{i}*Ri+repmat(Ti,[size(LL{i},1),1]);
    Mesh.UL{i}=UL{i}*Rs+repmat(Ts,[size(UL{i},1),1]);
    Mesh.LR{i}=LR{i}*Ri+repmat(Ti,[size(LR{i},1),1]);
    Mesh.UR{i}=UR{i}*Rs+repmat(Ts,[size(UR{i},1),1]);
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
 fo.Normalize='on';
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


tmpscript;

BB=flipud(generatedimg);
Uimg=BB;
Umark=markedpoint;
imshow(BB)
hold on ;scatter(markedpoint(:,1),size(Uimg,1)-markedpoint(:,2),'r*');hold off


index=find(BB>1);
Upoints=zeros(size(index,1),2);
Upoints(:,2)=floor(mod(index,size(BB,1)))+pixel_point.y(1)-size(BB,1)/4;
Upoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);
 %mixshow






%% L

vertex=[];
for i=1:7
    vertex=[vertex;Mesh.LL{i};Mesh.LR{i}];
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

markpoint=featureL.point*Ri;
for i=1:size(markpoint,1)
    
 slices(floor((markpoint(i,1)-tmp.XLimits(1))*scalez+1),floor((markpoint(i,2)-tmp.YLimits(1))*scalez+1),floor((markpoint(i,3)-tmp.ZLimits(1))*scalez+1))=255;
end



tmpscript;

BB=flipud(generatedimg);
Limg=BB;
Lmark=markedpoint;
figure;
imshow(BB)
hold on ;scatter(markedpoint(:,1),size(Limg,1)-markedpoint(:,2),'r*');hold off



index=find(BB>1);
Lpoints=zeros(size(index,1),2);
Lpoints(:,2)=floor(mod(index,size(BB,1)))+Ts(3)-size(BB,1)/4;
Lpoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);

%  figure;
%   scatter(Lpoints(:,1),Lpoints(:,2));hold on;
% scatter(Upoints(:,1),Upoints(:,2));hold on;
% imshow(paranoimg);alpha(0.5);axis on
 figure;imshow(paranoimg);axis on;hold on;
  scatter(Lpoints(:,1),Lpoints(:,2));
scatter(Upoints(:,1),Upoints(:,2));hold on;

