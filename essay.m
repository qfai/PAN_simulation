
name='qjh'
savemesh=1;
meshpath='D:\volume\volume_data\data\2_000006qianjiahong\c.repairing\';
load_all;

global pointU;
global pointL;
global B;
pointU=featureU.point;
pointL=featureL.point;
B=U(:,2)-repmat(U(1,2),[size(U,1),1]);
fun = @regifun;
x0 = [10,1,0,1,0]; 
x = fsolve(fun,x0);

param=x;
scale=param(1)
a=param(2);%cos(alpha)
b=param(3);
c=param(4);
d=param(5);
Rs=scale*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
transed=pointU*Rs;
Ts=[0,U(1,1)-transed(1,2),U(1,2)-transed(1,3)];

% pointU=featureL.point;
% B=L(:,2)-repmat(L(1,2),[size(L,1),1]);
% fun = @regifun;
pointU=pointU*Rs;
B=U(:,2)-L(:,2);
fun = @regifun2;
% pointU=pointL;
% B=L(:,2)-repmat(L(1,2),[size(L,1),1]);
% fun = @regifun;
x0 = [10,1,0,1,0]; 
x = fsolve(fun,x0);
scale=param(1)
a=param(2);%cos(alpha)
b=param(3);
c=param(4);
d=param(5);
Ri=scale*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
transed=pointL*Ri;
Ti=[0,L(1,1)-transed(1,2),L(1,2)-transed(1,3)];

% upoint=featureU.point-repmat(featureU.point(1,:),[size(featureU.point,1),1]);
% [Rs,Ts,Ri,Ti,SCALE]=RegisterbyIterTheta(featureU.point,U,featureL.point,L);
Mesh.LL={};
Mesh.LR={};
Mesh.UL={};
Mesh.UR={};
for i=1:7
    Mesh.LL{i}=LL{i}*Ri;
    Mesh.UL{i}=UL{i}*Rs;
    Mesh.LR{i}=LR{i}*Ri;
    Mesh.UR{i}=UR{i}*Rs;
end

% figure;
% hold on;
% for i=1:7
% m=Mesh.UL{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% m=Mesh.UR{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% m=Mesh.LL{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% m=Mesh.LR{i};
% scatter(m(:,2),repmat(size(paranoimg,1),[size(m,1),1])-m(:,3));
% end
% imshow(paranoimg);
% alpha(0.5);
% title('after rotation');
% hold off 

vertex=[];
for i=1:7
    vertex=[vertex;Mesh.LL{i};Mesh.LR{i};Mesh.UL{i};Mesh.UR{i}];
end
%  pop=[featureL.minYpoint(:,2);featureL.maxYpoint(:,2);featureU.minYpoint(:,2);featureU.maxYpoint(:,2)];
% cdata=[featureL.minYpoint(:,1);featureL.maxYpoint(:,1);featureU.minYpoint(:,1);featureU.maxYpoint(:,1)];
pop=[featureL.minYpoint*Ri;featureL.maxYpoint*Ri;featureU.minYpoint*Rs;featureU.maxYpoint*Rs];
cdata=pop(:,1);
pop=pop(:,2);
 fo = fitoptions('Method','NonlinearLeastSquares');
g = fittype('a*x^4+b*x^3+d*x+e','option',fo);
%g = fittype('a*x^2+b*x+c','option',fo);
 [curve2,gof2] = fit(pop,cdata,g);
 curve2
 figure;
 scatter(vertex(:,2),vertex(:,1));
hold on
plot(curve2,'m')
 minx=min(pop);
 maxx=max(pop);
 sample_number=100;%floor(size(paranoimg,1)*4/3);
pixel_size=0.1;


generate_U;
generate_L;




 figure;
  scatter(Lpoints(:,1),size(paranoimg,1)-Lpoints(:,2));hold on;
scatter(Upoints(:,1),size(paranoimg,1)-Upoints(:,2));hold on;
scatter(markedu(:,1)+1+pixel_point.x(1),size(paranoimg,1)-(markedu(:,2)+min(U(:,2))),'r*');
scatter(lmarked(:,1)+1+pixel_point.x(1),size(paranoimg,1)-(lmarked(:,2)+max(L(:,2))-max(lmarked(:,2))),'r*');
scatter(Lroot(:,1),Lroot(:,2),'r*')
scatter(U(:,1),size(paranoimg,1)-U(:,2),'b*');
scatter(L(:,1),size(paranoimg,1)-L(:,2),'b*');
f=imshow(paranoimg);set(f,'AlphaData',0.5);axis on






%% get contour
% index=find(BB>1);
% Lpoints=zeros(size(index,1),2);
% %Upoints(:,2)=floor(mod(index,size(BB,1)))+ Ts(3)-max(markedpoint(:,2));
% Lpoints(:,2)=floor(mod(index,size(BB,1)));
% Lpoints(:,1)=floor((index-1)/size(BB,1));
% 
% [idx,C]=kmedoids(Lpoints,14);
% figure;hold on;imshow(BB);
% hold on 
% for i=1:14
% scatter(Lpoints(idx==i,1),Lpoints(idx==i,2))
% end
%  index=find(idx==1);
%  k=boundary(Lpoints(index,1),Lpoints(index,2));
%  
%  
%  start(6,:)=sum(tmpL(6:7,:))/2;
