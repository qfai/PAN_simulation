img=idx-1;
neigb=[-1 0; 1 0; 0 -1;0 1;-1,-1;1,1;-1,1;1,-1];
queue=[];
count=0;
scount=1;
discard=size(subimg,1)*size(subimg,2)*0.08;
label=2;

for i=1:size(img,1)
    for j=1:size(img,2)
         scount=0;
         count=0;
        if(img(i,j)==1)
            img(i,j)=label;
            queue=[i,j];
            count=count+1;
            scount=scount+1;
            while count>0
                point=queue(count,:);
                count=count-1;
                for k=1:size(neigb,1)
                    testpoint=point+neigb(k,:);
                    if(testpoint(1)<=0||testpoint(1)>size(img,1)||testpoint(2)<=0||testpoint(2)>size(img,2))
                        continue;
                    end
                    if(img(testpoint(1),testpoint(2))==1)
                        img(testpoint(1),testpoint(2))=label;
                        count=count+1;
                        scount=scount+1;
                        if(size(queue,1)>=count)
                            queue(count,:)=testpoint;
                        else
                            queue=[queue;testpoint];
                        end
                    end
                end
            end
            if(scount>0&&scount<discard)
                scount
                count=0;
                img(i,j)=0;
            queue=[i,j];
            count=count+1;
            while count>0
                point=queue(count,:);
                count=count-1;
                for k=1:size(neigb,1)
                     testpoint=point+neigb(k,:);
                    if(testpoint(1)<=0||testpoint(1)>size(img,1)||testpoint(2)<=0||testpoint(2)>size(img,2))
                        continue;
                    end
                    if(img(testpoint(1),testpoint(2))==label)
                        img(testpoint(1),testpoint(2))=0;
                        count=count+1;
                        scount=scount+1;
                        if(size(queue,1)>=count)
                            queue(count,:)=testpoint;
                        else
                            queue=[queue;testpoint];
                        end
                    end
                end
            end
            else
                label=label+1;
            end
           
        end
        
    end
end
figure;
imshow(img/2);