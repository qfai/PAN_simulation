paranoimg=imread('sx.jpg');
mesh=readObj('D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\whole.obj');
vertex=mesh.v;

load('sunxia_pan_point.mat')

meshfea=textread('sunxia.fea');
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

%slices
tmp=pointCloud(vertex);
scalez=10;
ZLimits=floor((tmp.ZLimits(2)-tmp.ZLimits(1))*scalez)+1;
XLimits=floor((tmp.XLimits(2)-tmp.XLimits(1))*scalez)+1;
YLimits=floor((tmp.YLimits(2)-tmp.YLimits(1))*scalez)+1;
slices=zeros(XLimits,YLimits,ZLimits);
for i=1:size(vertex,1)
    slices(floor((vertex(i,1)-tmp.XLimits(1))*scalez+1),floor((vertex(i,2)-tmp.YLimits(1))*scalez+1),floor((vertex(i,3)-tmp.ZLimits(1))*scalez+1))=1;
end
%Get fit data

%fit
% scatter(vertex(:,1),vertex(:,2));
% [cdata,pop]=ginput(10);
% scatter(vertex(:,1),vertex(:,2));
% hold on
% scatter(featureU.minYpoint(:,1),featureU.minYpoint(:,2),'r')
% scatter(featureU.maxYpoint(:,1),featureU.maxYpoint(:,2),'r*')
% scatter(featureL.minYpoint(:,1),featureL.minYpoint(:,2),'b')
% scatter(featureL.maxYpoint(:,1),featureL.maxYpoint(:,2),'b*')
pop=[featureL.minYpoint(:,2);featureL.maxYpoint(:,2);featureU.minYpoint(:,2);featureU.maxYpoint(:,2)];
cdata=[featureL.minYpoint(:,1);featureL.maxYpoint(:,1);featureU.minYpoint(:,1);featureU.maxYpoint(:,1)];
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

% generatedimg=[];
% sample_number=1000;
%  %first assume uniform sample
%  for i=minx:(0-minx)/sample_number:0 %half
%      tmpimg=[];
%     y=curve2.a*i*i*i*i+curve2.b*i*i*i+curve2.d*i+curve2.e;
%     dy=4*curve2.a*i*i*i+3*curve2.b*i*i+curve2.d;
%     if abs(dy)<=0.0001
%         
%     else
%     k=-1/(dy);
%     x0=[0,k*(0-i)+y;tmp.YLimits(1),k*(tmp.YLimits(1)-i)+y];
%     end
%     theta=180-atan(k);
%     prepoint=round(transformpoint([x0(2,2),x0(2,1)],tmp,scalez));
%     for x=x0(2,1):x0(1,1)
%         
%         point=round(transformpoint([x0(2,2),x],tmp,scalez));
%         if(round(prepoint(1))>size(slices,1))
%             prepoint=point;
%             continue;
%         end
%         if(round(point(1))<0)
%             break;
%         end
%         if(point==prepoint)
%          x0(2,2)=x0(2,2)+k;
%           prepoint=point;
%          continue;
%         elseif(point(1)==prepoint(1))
%              for xx=prepoint(2):point(2)
%                 tmpimg=[tmpimg,permute(slices(point(1),round(xx),:),[3,1,2])];
%              end
%         else
%         
%         %draw a line here
%         linek=(point(2)-prepoint(2))/(point(1)-prepoint(1));
%         
%         if abs(linek)<=1
%             if(prepoint(1)>point(1))
%                 beginx=point(1);
%                 endx=prepoint(1);
%                 y=point(2);
%             else
%                 beginx=prepoint(1);
%                 endx=point(1);
%             y=prepoint(2);
%             end
%             for xx=beginx:endx
%                 tmpimg=[tmpimg,permute(slices(xx,round(y),:),[3,1,2])];
%                  y=y+linek;
%             end
%         else
%              if(prepoint(2)>point(2))
%                 beginx=point(2);
%                 endx=prepoint(2);
%                 xx=point(1);
%             else
%                 beginx=prepoint(2);
%                 endx=point(2);
%                 xx=prepoint(1);
%              end
%             for y=beginx:endx
%                 tmpimg=[tmpimg,permute(slices(round(xx),y,:),[3,1,2])];
%                  xx=xx+1/linek;
%             end
%         end
%         end
%        % tmpimg=[tmpimg,permute(slices(point(1),point(2),:),[3,1,2])];
%        prepoint=point;
%         
%     end
%     [xxx,xp]=radon(tmpimg,theta);
%     if(size(xxx,1)>size(generatedimg,1))
%         newgeimg=zeros(size(xxx,1),size(generatedimg,2));
%         newgeimg(1:size(generatedimg,1),1:size(generatedimg,2))=generatedimg;
%         generatedimg=newgeimg;
%          generatedimg=[generatedimg,xxx];
%     else
%         xx=zeros(size(generatedimg,1),1);
%         xx(1:size(xxx,1),1)=xxx;
%          generatedimg=[generatedimg,xx];
%     end
%    
%  end
%  imshow(generatedimg);
 %get the img
 
 
%radon transformation

%% generate img feature data
% imshow(paranoimg)
% hold on
% [lx,ly]=ginput(18);
% [ux,uy]=ginput(18);
% scatter(lx,ly)
% scatter(ux,uy)
% PAN_align_point.U=[ux,uy];
% PAN_align_point.L=[lx,ly];
% [rootx,rooty]=ginput(18);
% scatter(rootx,rooty)
% PAN_align_point.Lroot=[rootx,rooty];
% [rootx,rooty]=ginput(18);
% scatter(rootx,rooty)
% PAN_align_point.Uroot=[rootx,rooty];

%% scale of z is 10
%tmp=pointCloud(vertex);
% U(1)-L(1)
% ans =
%     46
% meshfea(1,:)-meshfea(19,:)
% ans =
%    -6.2819   -1.6579    4.6463
%% load single tooth mesh each
% meshpath='D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\';
% tmp=readObj([meshpath,'U\UL',num2str(1),'.obj']);
% toothmesh.U={tmp.v};
% for i=2:7
%     tmp=readObj([meshpath,'U\UL',num2str(i),'.obj']);
%     toothmesh.U=[ toothmesh.U,{tmp.v}];
% end
% for i=1:7
%     tmp=readObj([meshpath,'U\UR',num2str(i),'.obj']);
%     toothmesh.U=[ toothmesh.U,{tmp.v}];
% end
% tmp=readObj([meshpath,'L\LL',num2str(1),'.obj']);
% toothmesh.L={tmp.v};
% for i=2:7
%     tmp=readObj([meshpath,'L\LL',num2str(i),'.obj']);
%     toothmesh.L=[ toothmesh.L,{tmp.v}];
% end
% for i=1:7
%     tmp=readObj([meshpath,'L\LR',num2str(i),'.obj']);
%     toothmesh.L=[ toothmesh.L,{tmp.v}];
% end
% 
% %calibration
% 
% %show
% showtooth(toothmesh);