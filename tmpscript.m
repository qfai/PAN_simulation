generatedimg=[];
%imshow(paranoimg)
%[pixel_point.x,pixel_point.y]=ginput(15);
minx=featureU.maxYpoint(14,2)*SCALE;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%here
featureU.minYpoint(14,2)=featureU.maxYpoint(13,2);
%minx=min(pop);
%minx=featureU.minYpoint(14,2);
pixel_count=1;
xcount=0;
for tooth_number=14:-1:8
maxx=featureU.minYpoint(tooth_number,2)*SCALE;
sample_number=round(pixel_point.x(pixel_count+1)-pixel_point.x(pixel_count));
pixel_count=pixel_count+1;

markedpoint=[];
 %first assume uniform sample
 for i=minx:(maxx-minx)/sample_number:maxx %half

    y=curve2.a*i*i*i*i+curve2.b*i*i*i+curve2.d*i+curve2.e;
    dy=4*curve2.a*i*i*i+3*curve2.b*i*i+curve2.d;
    nowpoint=transformpoint([y,i],tmp,scalez);
    if abs(dy)<=0.03
        point=transformpoint([0,i],tmp,scalez);
        tmpimg=permute(slices(:,round(point(2)),:),[3,1,2]);
         generatedimg=[generatedimg,sum(tmpimg,2)];
        
        continue;
    else
        k=-1*(dy);
        point1=[tmp.XLimits(2)-tmp.XLimits(1),-1];
        point2=[-1,1];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point1(2))<=0)
            firstpoint=floor(point2);
        else
            firstpoint=floor(point1);
        end
        
        point1=[1,-1];
        point2=[-1,round((tmp.YLimits(2)-tmp.YLimits(1))/2)];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point2(1))<=0)
            secondpoint=floor(point1);
        else
            secondpoint=floor(point2);
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


 minx=maxx;
end

for tooth_number=1:7
maxx=featureU.minYpoint(tooth_number,2)*SCALE;
sample_number=round(pixel_point.x(pixel_count+1)-pixel_point.x(pixel_count));
pixel_count=pixel_count+1;

 %first assume uniform sample
 for i=minx:(maxx-minx)/sample_number:maxx %half

    y=curve2.a*i*i*i*i+curve2.b*i*i*i+curve2.d*i+curve2.e;
    dy=4*curve2.a*i*i*i+3*curve2.b*i*i+curve2.d;
    nowpoint=transformpoint([y,i],tmp,scalez);
    if abs(dy)<=0.03
        point=transformpoint([0,i],tmp,scalez);
        tmpimg=permute(slices(:,round(point(2)),:),[3,1,2]);
         generatedimg=[generatedimg,sum(tmpimg,2)];
        
        continue;
    else
        k=-1*(dy);
        point1=[-1,round((tmp.YLimits(2)-tmp.YLimits(1))/2)];
        point2=[1,-1];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point1(1))<=0)
            firstpoint=floor(point2);
        else
            firstpoint=floor(point1);
        end
        
        point1=[round((tmp.XLimits(2)-tmp.XLimits(1))),-1];
        point2=[-1,round((tmp.YLimits(2)-tmp.YLimits(1)))];
        point1=line_point(nowpoint,k,point1);
        point2=line_point(nowpoint,k,point2);
        if(floor(point2(1))>round((tmp.XLimits(2)-tmp.XLimits(1))))
            secondpoint=floor(point1);
        else
            secondpoint=floor(point2);
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


 minx=maxx;
end

% %generatedimg(:,2)=size(generatedimg,1)-generatedimg(:,2);
%  imshow(generatedimg);
BB=flipud(generatedimg);
imshow(BB)
hold on ;scatter(markedpoint(:,1),markedpoint(:,2),'r*');hold off
 %mixshow

 index=find(BB>1);
  points=zeros(size(index,1),2);
points(:,2)=floor(mod(index,size(BB,1)))+Ti(3);
points(:,1)=floor((index-1)/size(BB,1))+1+pixel_point.x(1);
 figure;
  scatter(points(:,1),points(:,2));hold on;
imshow(paranoimg);alpha(0.5);axis on
