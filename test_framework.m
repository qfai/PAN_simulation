%%test framework

%% read data
load('sunxia_pan_point.mat');

load('sxmesh.mat');
paranoimg=imread('sx.jpg');
U(:,2)=repmat(size(paranoimg,1),[size(U,1),1])-U(:,2);
L(:,2)=repmat(size(paranoimg,1),[size(L,1),1])-L(:,2);


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

%% param
global pointU;
global pointL;
global B;
pointU=featureU.point;
pointL=featureL.point;
% % simple case
% scale=1.2;
% alpha=45/180*3.14;
% theta=30/180*3.14;
% 
% transed=pointU*scale*[1,0,0;0,cos(alpha),-1*sin(alpha);0,sin(alpha),cos(alpha)]*[cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
% B=transed(:,3)-transed(1,3);
% 
% 
% fun = @regifun;
% x0 = [0,0,1,0,1];
% x = fsolve(fun,x0);
% 
% 
% % simple case
% scale=11.2;
% alpha=5/180*3.14;
% theta=40/180*3.14;
% transed=pointU*scale*[1,0,0;0,cos(alpha),-1*sin(alpha);0,sin(alpha),cos(alpha)]*[cos(theta),0,sin(theta);0,1,0;-sin(theta),0,cos(theta)];
% B=transed(:,3)-transed(1,3)+rand()*10;

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
 imshow(paranoimg);hold on
scatter(U(:,1),size(paranoimg,1)-U(:,2));

 transed=transed+repmat(Ts,[size(transed,1),1]);
 scatter(transed(:,2 ),size(paranoimg,1)-transed(:,3));
%scatter(transed(:,2 )+Ts(2),size(paranoimg,1)-transed(:,3)-Ts(3));

sum(regifun(x))

pointU=pointU*Rs;
B=U(:,2)-L(:,2);
fun = @regifun2;
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

Mesh.UL={};
Mesh.UR={};
for i=1:7
   
    Mesh.UL{i}=UL{i}*Rs;%+repmat([0,0,Ts(3)-Ti(3)],[size(UL{i},1),1]);
    Mesh.UR{i}=UR{i}*Rs;%+repmat([0,0,Ts(3)-Ti(3)],[size(UR{i},1),1]);
end

vertex=[];
for i=1:7
    vertex=[vertex; Mesh.UL{i}; Mesh.UR{i}];
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
Upoints(:,2)=floor(mod(index,size(BB,1)))+pixel_point.y(1);
Upoints(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);
