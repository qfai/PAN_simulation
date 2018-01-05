%new method
function []=newmethod(tooth_path,pan_point_file,paraimgname,feafile,Uaxes,Laxes)
%get all objs

mesh.UL={};
mesh.UR={};
mesh.LL={};
mesh.LR={};
% load('sxmesh.mat');
% mesh.UL=UL;
% mesh.UR=UR;
% mesh.LL=LL;
% mesh.LR=LR;
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
    tmpname=[tooth_path,'L\LL',num2str(i),'.obj'];
    if(exist(tmpname,'file'))
        tmp=readObj(tmpname);
        if(size(mesh.LL)==0)
            mesh.LL={tmp.v};
        else
            mesh.LL=[mesh.LL,tmp.v];
        end
    end
    tmpname=[tooth_path,'L\LR',num2str(i),'.obj'];
    if(exist(tmpname,'file'))
    tmp=readObj(tmpname);
    if(size(mesh.LR)==0)
        mesh.LR={tmp.v};
    else
        mesh.LR=[mesh.LR,tmp.v];
    end
    end
end

%get all local axis
axesU=textread(Uaxes);
axesL=textread(Laxes);

%get featurepoint
paranoimg=imread(paraimgname);
load(pan_point_file);
U(:,2)=repmat(size(paranoimg,1),[size(U,1),1])-U(:,2);
L(:,2)=repmat(size(paranoimg,1),[size(L,1),1])-L(:,2);
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
%translation well
%assume UL1 is origin
newtmp;

end