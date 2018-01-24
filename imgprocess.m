paranoimg=imread('sx.jpg');
paranoimg=paranoimg(367:1203,590:2288);
%% subsample
 
ratio=1/2;

subimg=imresize(paranoimg,ratio,'nearest');
%subimg=subimg(50:size(subimg,1)-50,50:size(subimg,2)-50);
imshow(subimg)

%% APLT

w=10;%%%%%%%%%%%%%%%% not very confident, need to be even  w<=20 pratical speaking

gamma=zeros(size(subimg)-[w,w]);
%minconv=ones(size(subimg)-[w,w]);

for i=w/2+1:size(subimg,1)-w/2
    for j=w/2+1:size(subimg,2)-w/2
        maxconv=double(max(max(subimg(i-w/2:i+w/2,j-w/2:j+w/2))))/255;
        minconv=double(min(min(subimg(i-w/2:i+w/2,j-w/2:j+w/2))))/255;
        if(maxconv~=minconv)
            gamma(i-w/2,j-w/2)=(double(subimg(i,j))/255)^log(1/double(maxconv-minconv));
        else
             gamma(i-w/2,j-w/2)=(double(subimg(i,j))/255);
        end
    end
end
figure
imshow(gamma);
%gamma=histeq(gamma);
%% got alpha image
domainsize=5;% or 3 or 5
%ds=[1,3,5];
alpha=zeros(size(gamma)-[domainsize,domainsize]);
for i=floor(domainsize/2)+1:size(gamma,1)-floor(domainsize/2)
    for j=floor(domainsize/2)+1:size(gamma,2)-floor(domainsize/2)
        data=[];
        for k=1:2:5
            data=[data;log(k),log(sum(sum(gamma(i-floor(k/2):i+floor(k/2),j-floor(k/2):j+floor(k/2))))/k/k)];
        end
        p=polyfit(data(:,1),data(:,2),1);  
        
        alpha(i-floor(domainsize/2),j-floor(domainsize/2))=p(1);
    end
end
figure;imshow(alpha);title('alpha');

%% bilateral filter
sigmar=0.1;
sigmad=3;
blocksize=25;
alpha(find(alpha>1))=1;
alpha(find(alpha<0))=0;
bflt_img1 = bfilter2(alpha,blocksize,[sigmad,sigmar]);
figure;imshow(bflt_img1)



%% corse tooth segmentation
[idx,sep]=otsu(bflt_img1,2);
imshow(idx-1);
tmp=bflt_img1;tmp(find(tmp<=sep*0.8))=0;tmp(find(tmp>sep*0.8))=1;
imshow(tmp)
sepimg=im2bw(bflt_img1,sep*1.2);
imshow(sepimg)
img=idx-1;
neigb=[-1 0; 1 0; 0 -1;0 1;-1,-1;1,1;-1,1;1,-1];
queue=[];
count=0;
scount=1;
discard=size(subimg,1)*size(subimg,2)*0.001;
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
imshow(img);
%% fine segmentation
%initial contour

%level set

%% refinement 

original=img;
afterOpening = imopen(original,strel('disk',2));

afterClosing=imclose(afterOpening,strel('disk',2));
k=2;
pixelFIRST=zeros([label-2,2]);

for i=1:size(img,1)
    while k<label
        for j=1:size(img,2)
            if(img(i,j)==k)
                pixelFIRST(k-1,:)=[i,j];
                k=k+1;
            
            end
        end
    end
end
img=img/2;
[listCONTOUR,listNORMALS] = TRACE_MooreNeighbourhood(img,pixelFIRST);
