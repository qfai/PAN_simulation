count=0;
generatedimg=[];
%radon transform , theta =0 is projected by y axis,while 90 is x;
randoncenter=[floor((size(slices,1)+1)/2),floor((size(slices,2)+1)/2)];
transc=randoncenter+[tmp.XLimits(1),tmp.YLimits(1)];
for i=1:size(projectionpoint,1)-1
    k=1/dy(i);
    theta=acos(([0,-1]*[1,k]')/norm([1,k],2));
   % theta=pi-theta;
 
%     if(d<0)
%         theta=pi/2-theta;
%     else
%          theta=pi/2+theta;
%     end
    %point 2 point and then radon trans
    %%% seems like imshow it will swap x y axis
    tmpimg=[];
    coord=getcoord(theta,transc,projectionpoint(i:i+1,1:2));
    sample_number=pixel_point.x(i+1)-pixel_point.x(i);
    for j=1:size(slices,3)
        [x,xp]=radon(slices(:,:,j),theta);
         one=find(xp==coord(1));
        two=find(xp==coord(2));

           % step=(two-one)/sample_number;
            index=round(linspace(one,two,sample_number));
            tmpimg=[tmpimg;x(index)'];
    end
    generatedimg=[generatedimg tmpimg];
end
figure;
imshow(generatedimg);
