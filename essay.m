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
upoint=featureU.point-repmat(featureU.point(1,:),[size(featureU.point,1),1]);
[Rs,Ts,Ri,Ti,SCALE]=RegisterbyIterTheta(featureU.point,U,featureL.point,L);
Mesh.LL={};
Mesh.LR={};
Mesh.UL={};
Mesh.UR={};
for i=1:7
    Mesh.LL{i}=LL{i}*Ri;%+repmat(Ti,[size(LL{i},1),1]);
    Mesh.UL{i}=UL{i}*Rs+repmat([0,0,Ts(3)-Ti(3)],[size(UL{i},1),1]);
    Mesh.LR{i}=LR{i}*Ri;%+repmat(Ti,[size(LR{i},1),1]);
    Mesh.UR{i}=UR{i}*Rs+repmat([0,0,Ts(3)-Ti(3)],[size(UR{i},1),1]);
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

vertex=[];
for i=1:7
    vertex=[vertex;Mesh.LL{i};Mesh.UL{i};Mesh.UR{i};Mesh.LR{i}];
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
markpoint=featureU.point*Rs+repmat([0,0,Ts(3)-Ti(3)],[size(featureU.point,1),1]);
for i=1:size(markpoint,1)
    
 slices(floor((markpoint(i,1)-tmp.XLimits(1))*scalez+1),floor((markpoint(i,2)-tmp.YLimits(1))*scalez+1),floor((markpoint(i,3)-tmp.ZLimits(1))*scalez+1))=255;
end
markpoint=featureL.point*Ri;%+repmat([0,0,Ts(3)-Ti(3)],[size(featureL.point,1),1]);
for i=1:size(markpoint,1)
    
 slices(floor((markpoint(i,1)-tmp.XLimits(1))*scalez+1),floor((markpoint(i,2)-tmp.YLimits(1))*scalez+1),floor((markpoint(i,3)-tmp.ZLimits(1))*scalez+1))=255;
end

%  rotatedminL=[featureL.minYpoint*Ri+repmat(Ti,[size(featureL.minYpoint,1),1])];
% rotatedmaxL=[featureL.maxYpoint*Ri+repmat(Ti,[size(featureL.maxYpoint,1),1])];
% rotatedminU=[featureU.minYpoint*Rs+repmat(Ts,[size(featureU.minYpoint,1),1])];
% rotatedmaxU=[featureU.maxYpoint*Rs+repmat(Ts,[size(featureU.maxYpoint,1),1])];
% pop=[rotatedminL(:,2);rotatedmaxL(:,2);rotatedminU(:,2);rotatedmaxU(:,2)];
% cdata=[rotatedminL(:,1);rotatedmaxL(:,1);rotatedminU(:,1);rotatedmaxU(:,1)];

pop=[featureL.minYpoint(:,2);featureL.maxYpoint(:,2);featureU.minYpoint(:,2);featureU.maxYpoint(:,2)]*SCALE;
cdata=[featureL.minYpoint(:,1);featureL.maxYpoint(:,1);featureU.minYpoint(:,1);featureU.maxYpoint(:,1)]*SCALE;
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


