generatedimg=[];
sample_number=1000;
 %first assume uniform sample
 for i=minx:(0-minx)/sample_number:0 %half
     tmpimg=[];
    y=curve2.a*i*i*i*i+curve2.b*i*i*i+curve2.d*i+curve2.e;
    dy=4*curve2.a*i*i*i+3*curve2.b*i*i+curve2.d;
    if abs(dy)<=0.0001
        continue;
    else
    k=-1/(dy);
    x0=[0,k*(0-i)+y;tmp.YLimits(1),k*(tmp.YLimits(1)-i)+y];
    end
    theta=180-atan(k);
    prepoint=round(transformpoint([x0(2,2),x0(2,1)],tmp,scalez));
    for x=x0(2,1):x0(1,1)
        
        point=round(transformpoint([x0(2,2),x],tmp,scalez));
        if(round(prepoint(1))>size(slices,1))
            prepoint=point;
            continue;
        end
        if(round(point(1))<=0)
            continue;
        end
        if(point==prepoint)
         x0(2,2)=x0(2,2)+k;
          prepoint=point;
         continue;
        elseif(point(1)==prepoint(1))
             for xx=prepoint(2):point(2)
                tmpimg=[tmpimg,permute(slices(point(1),round(xx),:),[3,1,2])];
             end
        else
        
        %draw a line here
        linek=(point(2)-prepoint(2))/(point(1)-prepoint(1));
        
        if abs(linek)<=1
            if(prepoint(1)>point(1))
                beginx=point(1);
                endx=prepoint(1);
                y=point(2);
            else
                beginx=prepoint(1);
                endx=point(1);
            y=prepoint(2);
            end
            for xx=beginx:endx
                tmpimg=[tmpimg,permute(slices(xx,round(y),:),[3,1,2])];
                 y=y+linek;
            end
        else
             if(prepoint(2)>point(2))
                beginx=point(2);
                endx=prepoint(2);
                xx=point(1);
            else
                beginx=prepoint(2);
                endx=point(2);
                xx=prepoint(1);
             end
            for y=beginx:endx
                tmpimg=[tmpimg,permute(slices(round(xx+1),y,:),[3,1,2])];%%%%%%%%%%%%%%%
                 xx=xx+1/linek;
            end
        end
        end
       % tmpimg=[tmpimg,permute(slices(point(1),point(2),:),[3,1,2])];
       prepoint=point;
        
    end
    xxx=sum(tmpimg,2);%[xxx,xp]=radon(tmpimg,theta);
    if(size(xxx,1)>size(generatedimg,1))
        newgeimg=zeros(size(xxx,1),size(generatedimg,2));
        newgeimg(1:size(generatedimg,1),1:size(generatedimg,2))=generatedimg;
        generatedimg=newgeimg;
         generatedimg=[generatedimg,xxx];
    else
        xx=zeros(size(generatedimg,1),1);
        xx(1:size(xxx,1),1)=xxx;
         generatedimg=[generatedimg,xx];
    end
   
 end
 imshow(generatedimg);