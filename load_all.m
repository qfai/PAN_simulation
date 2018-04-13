%initial pathes

%param
% user_path: to specify img data
% user_output_path:if not specified, then = user_path
%savemesh=1 means save mesh to 
%name the name of user, must specify

if(~exist('name','var')&&~isa(name,'char'))
    disp('do not specify a string name varible');
    finish();
end
if(~exist('user_path','var'))
    path=['data\',name];
else
    path=user_path;
end
imgfile=[path,'\',name,'.jpg'];
if(exist(imgfile,'file'))
    paranoimg=imread(imgfile);
else
    disp('cant find imgfile');
end

%pan_point
pan_point_file=[path,'\',name,'_pan_point.mat'];
if(~exist(pan_point_file,'file'))
    imshow(paranoimg);hold on;
    disp('please choose 18 feature point of upper jar,from UL1:UL7,UR1:UR7');
    U=zeros(18,2);
    [U(:,1),U(:,2)]=ginput(18);
    scatter(U(:,1),U(:,2));
    disp('please choose 18 feature point of lower jar,from LL1:LL7,LR1:LR7');
    L=zeros(18,2);
    [L(:,1),L(:,2)]=ginput(18);
    scatter(L(:,1),L(:,2));
    U(:,2)=repmat(size(paranoimg,1),[size(U,1),1])-U(:,2);
L(:,2)=repmat(size(paranoimg,1),[size(L,1),1])-L(:,2);

 disp('please choose 18 root point of uppper jar,from left to right');
    Uroot=zeros(18,2);
     [Uroot(:,1),Uroot(:,2)]=ginput(18);
     scatter(Uroot(:,1),Uroot(:,2));
      disp('please choose 18 root point of lower jar,from left to right');
    Lroot=zeros(18,2);
     [Lroot(:,1),Lroot(:,2)]=ginput(18);
      scatter(Lroot(:,1),Lroot(:,2));
 disp('please choose 15 sample point of uppper jar,from left to right');
 pixel_point.x=zeros(15,1);
  pixel_point.y=zeros(15,1);
  [pixel_point.x,pixel_point.y]=ginput(15);
  scatter(pixel_point.x,pixel_point.y);hold off;
  %save
  pan_point.U=U;
  pan_point.L=L;
  pan_point.Uroot=Uroot;
  pan_point.Lroot=Lroot;
  pan_point.pixel_point=pixel_point;
  
  save(pan_point_file,'-struct','pan_point');
else
    load(pan_point_file);
end


if(exist('reloadmesh','var')&&reloadmesh==1)
    
tmp=readObj([meshpath,'U\UL',num2str(1),'.obj']);
UL=[{tmp.v(:,1:3)}];
for i=2:7
    tmp=readObj([meshpath,'U\UL',num2str(i),'.obj']);
    UL=[UL,{tmp.v(:,1:3)}];
end
UR=[];
for i=1:7
    tmp=readObj([meshpath,'U\UR',num2str(i),'.obj']);
    UR=[ UR,{tmp.v(:,1:3)}];
end
tmp=readObj([meshpath,'L\LL',num2str(1),'.obj']);
LL=[{tmp.v(:,1:3)}];
for i=2:7
    tmp=readObj([meshpath,'L\LL',num2str(i),'.obj']);
    LL=[ LL,{tmp.v(:,1:3)}];
end
LR=[];
for i=1:7
    tmp=readObj([meshpath,'L\LR',num2str(i),'.obj']);
    LR=[LR,{tmp.v(:,1:3)}];
end
 

else

mesh_file=[path,'\',name,'mesh.mat'];
if(~exist(mesh_file,'file'))
    if(~exist('meshpath','var'))
        disp('did not specify meshpath variables');
        finish();
    end
   % meshpath='D:\volume\volume_data\data\4_000009sunxia\sunxia-cbctmesh\c.Repairing1\';
tmp=readObj([meshpath,'U\UL',num2str(1),'.obj']);
UL=[{tmp.v}];
for i=2:7
    tmp=readObj([meshpath,'U\UL',num2str(i),'.obj']);
    UL=[UL,{tmp.v}];
end
UR=[];
for i=1:7
    tmp=readObj([meshpath,'U\UR',num2str(i),'.obj']);
    UR=[ UR,{tmp.v}];
end
tmp=readObj([meshpath,'L\LL',num2str(1),'.obj']);
LL=[{tmp.v}];
for i=2:7
    tmp=readObj([meshpath,'L\LL',num2str(i),'.obj']);
    LL=[ LL,{tmp.v}];
end
LR=[];
for i=1:7
    tmp=readObj([meshpath,'L\LR',num2str(i),'.obj']);
    LR=[LR,{tmp.v}];
end
    if( exist('savemesh','var')&&savemesh==1)
        mesh.UL=UL;
        mesh.LL=LL;
        mesh.LR=LR;
        mesh.UR=UR;
        save(mesh_file,'-struct','mesh');
    end
    else
    load(mesh_file);
end

end



feafile=[path,'\',name,'_l.fea'];%'Ltest.fea';

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

feafile=[path,'\',name,'_u.fea'];

meshfea=textread(feafile);
meshfea=meshfea(:,1:3);
count=1;
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

% pixel_point.x=1.0e+03 *[
% 
%     0.8275
%     0.9575
%     1.0815
%     1.1575
%     1.2315
%     1.3115
%     1.3815
%     1.4595
%     1.5395
%     1.6095
%     1.6935
%     1.7755
%     1.8595
%     1.9835
%     2.1255];
% pixel_point.y=[  613.0000
%   627.0000
%   639.0000
%   661.0000
%   671.0000
%   671.0000
%   673.0000
%   671.0000
%   673.0000
%   673.0000
%   677.0000
%   677.0000
%   683.0000
%   653.0000
%   639.0000];