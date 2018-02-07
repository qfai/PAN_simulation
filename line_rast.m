function [ img ] = line_rast(slices,point1,point2,k)
% %line rasterization
%   此处显示详细说明
if(point1(1)==0)
    point1(1)=1;
end
if(point2(1)==0)
    point2(1)=1;
end
if(point1(2)==0)
    point1(2)=1;
end
if(point2(2)==0)
    point2(2)=1;
end
k=(point2(2)-point1(2))/(point2(1)-point1(1));
img=[];
    if(abs(k)<1)
        if(point1(1)>point2(1))
            tmp=point1;
            point1=point2;
            point2=tmp;
        end
        y=point1(2);
        for x=point1(1):point2(1)
            img=[img,permute(slices(x,round(y),:),[3,1,2])];
            y=y+k;
        end
    else
        k=1/k;
         if(point1(2)>point2(2))
            tmp=point1;
            point1=point2;
            point2=tmp;
         end
        x=point1(1);
         for y=point1(2):point2(2)
            img=[img,permute(slices(round(x),y,:),[3,1,2])];
            x=x+k;
        end
    end

end

