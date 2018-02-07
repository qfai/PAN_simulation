generatedimg=[];
% imshow(paranoimg)
% [pixel_point.x,pixel_point.y]=ginput(15);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%here
featureU.minYpoint(14,2)=featureU.maxYpoint(13,2);
minx=featureU.maxYpoint(14,:)*Rs;
yo=minx(1);
minx=minx(2);
%minx=min(pop);
%minx=featureU.minYpoint(14,2);
pixel_count=1;
xcount=0;
[minx,yo,dy]=get_nearest_point( [minx,yo],curve2);
for tooth_number=14:-1:8
maxx=featureU.minYpoint(tooth_number,:)*Rs;
yl=maxx(1);
maxx=maxx(2);
sample_number=round(pixel_point.x(pixel_count+1)-pixel_point.x(pixel_count));
pixel_count=pixel_count+1;
[maxx,yl,dy]=get_nearest_point( [maxx,yl],curve2);
if(tooth_number==13)
 sample_number
end
markedpoint=[];
 %first assume uniform sample
 for i=1:sample_number
 %for i=minx:(maxx-minx)/sample_number:maxx %half
    x=minx+(maxx-minx)/sample_number*i;
    y=yo+(yl-yo)/sample_number*i;
   dy=4*curve2.a*x*x*x+3*curve2.b*x*x+curve2.d;
     
     
    %y=curve2.a*i*i*i*i+curve2.b*i*i*i+curve2.d*i+curve2.e;
    %dy=4*curve2.a*i*i*i+3*curve2.b*i*i+curve2.d;
    nowpoint=transformpoint([y,x],tmp,scalez);
    if abs(dy)<=0.03
        point=transformpoint([0,x],tmp,scalez);
        tmpimg=permute(slices(:,round(point(2)),:),[3,1,2]);
         generatedimg=[generatedimg,sum(tmpimg,2)];
        
        continue;
    else
        k=-1*(dy);
        point1=[tmp.XLimits(2)-tmp.XLimits(1),-1];
        point2=[-1,round((tmp.YLimits(2)-tmp.YLimits(1)))];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point1(2))<=0)
            firstpoint=floor(point2);
        else
            firstpoint=floor(point1);
        end
        if firstpoint(1)<=0||firstpoint(1)>size(slices,1)||firstpoint(2)<=0||firstpoint(2)>size(slices,2)
            continue;
        end
        point1=[1,-1];
        point2=[-1,round((tmp.YLimits(2)-tmp.YLimits(1))/2)];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point2(1))<=0)
            secondpoint=floor(point1);
        else
            secondpoint=round(point2);
        end
        if secondpoint(1)<=0||secondpoint(1)>size(slices,1)||secondpoint(2)<=0||secondpoint(2)>size(slices,2)
            continue;
        end
           theta=180-atan(k);
           tmpk=(secondpoint(2)-firstpoint(2))/(secondpoint(1)-firstpoint(1));
           tmpimg=line_rast(slices,firstpoint,secondpoint,tmpk);
             tmpimg=sum(tmpimg,2);
            if size(find(tmpimg>254),1)>0
                index=find(tmpimg>254);
                for kkk=1:size(index)
                    markedpoint=[markedpoint;size(generatedimg,2)+1,index(kkk)];
                end
            end
           generatedimg=[generatedimg,tmpimg];
    end
   
  
end

yo=yl;
 minx=maxx;
end

for tooth_number=1:7
 maxx=featureU.minYpoint(tooth_number,:)*Rs;
yl=maxx(1);
maxx=maxx(2);
sample_number=round(pixel_point.x(pixel_count+1)-pixel_point.x(pixel_count));
pixel_count=pixel_count+1;
[maxx,yl,dy]=get_nearest_point( [maxx,yl],curve2);

 %first assume uniform sample
 for i=1:sample_number %half

    x=minx+(maxx-minx)/sample_number*i;
    y=yo+(yl-yo)/sample_number*i;
   dy=4*curve2.a*x*x*x+3*curve2.b*x*x+curve2.d;
   
    nowpoint=transformpoint([y,x],tmp,scalez);
    if abs(dy)<=0.03
        point=transformpoint([0,x],tmp,scalez);
        tmpimg=permute(slices(:,round(point(2)),:),[3,1,2]);
         generatedimg=[generatedimg,sum(tmpimg,2)];
        
        continue;
    else
        k=-1*(dy);
        point1=[-1,round((tmp.YLimits(2)-tmp.YLimits(1))/2)];
        point2=[1,-1];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point1(1))<=0||floor(point1(1))>round((tmp.XLimits(2)-tmp.XLimits(1))))
            firstpoint=floor(point2);
        else
            firstpoint=floor(point1);
        end
        
        point1=[round((tmp.XLimits(2)-tmp.XLimits(1))),-1];
       % point2=[-1,round((tmp.YLimits(2)-tmp.YLimits(1)))];
       point2=[-1,1];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point2(1))<0||floor(point2(1))>round((tmp.XLimits(2)-tmp.XLimits(1))))
            secondpoint=floor(point1);
        else
            secondpoint=round(point2);
        end
           theta=180-atan(k);
           tmpk=(secondpoint(2)-firstpoint(2))/(secondpoint(1)-firstpoint(1));
           tmpimg=line_rast(slices,firstpoint,secondpoint,tmpk);
          tmpimg=sum(tmpimg,2);
            if size(find(tmpimg>254),1)>0
                index=find(tmpimg>254);
                for kkk=1:size(index)
                    markedpoint=[markedpoint;size(generatedimg,2)+1,index(kkk)];
                end
            end
           generatedimg=[generatedimg,tmpimg];
    end
   
  
end

yo=yl;
 minx=maxx;
end


%% test sample point 
% featureU.minYpoint(14,2)=featureU.maxYpoint(13,2);
% minx=featureU.maxYpoint(14,:)*Rs;
% yo=minx(1);
% minx=minx(2);
% plot(curve2,'m');hold on ;
% scatter(minx,yo,'r*'); 
% [minx,yo,dy]=get_nearest_point( [minx,yo],curve2);
% for tooth_number=14:-1:8
% maxx=featureU.minYpoint(tooth_number,:)*Rs;
% yl=maxx(1);
% maxx=maxx(2);
% scatter(maxx,yl,'r*'); 
% [maxx,yl,dy]=get_nearest_point( [maxx,yl],curve2);
%   
% 
%  scatter(minx,yo); 
%  yo=yl;
%  minx=maxx;
% end
% scatter(minx,yo); 