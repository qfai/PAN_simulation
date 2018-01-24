%% test volization

filepathu='D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\U.obj';
mesh=readObj(filepathu);
filepathl='D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\L.obj';
meshl=readObj(filepathl);
vu=pointCloud(meshu.v*Rs);
vl=pointCloud(meshl.v*Ri);

[stlcoords] = READ_stl('D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\U.stl');
for i=1:size(stlcoords,1)
    stlcoords(i,:,:)=permute((permute(stlcoords(i,:,:),[3,2,1])*Rs),[3,2,1]);
end
[OUTPUTgrid] = VOXELISE(floor(vu.XLimits(2)-vu.XLimits(1)+1),floor(vu.YLimits(2)-vu.YLimits(1)+1),floor(vu.ZLimits(2)-vu.ZLimits(1)+1),'D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\U.stl','xyz');
 pop=[featureL.minYpoint;featureL.maxYpoint;featureU.minYpoint;featureU.maxYpoint]*Rs;
cdata=pop(:,1);
pop=pop(:,2);


% pop=[featureL.minYpoint(:,2);featureL.maxYpoint(:,2);featureU.minYpoint(:,2);featureU.maxYpoint(:,2)]*SCALE;
% cdata=[featureL.minYpoint(:,1);featureL.maxYpoint(:,1);featureU.minYpoint(:,1);featureU.maxYpoint(:,1)]*SCALE;
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

pixel_point.x=1.0e+03 *[

    0.8275
    0.9575
    1.0815
    1.1575
    1.2315
    1.3115
    1.3815
    1.4595
    1.5395
    1.6095
    1.6935
    1.7755
    1.8595
    1.9835
    2.1255];
pixel_point.y=[  613.0000
  627.0000
  639.0000
  661.0000
  671.0000
  671.0000
  673.0000
  671.0000
  673.0000
  673.0000
  677.0000
  677.0000
  683.0000
  653.0000
  639.0000];


tmp=vu;
 scalez=1;
tmpscript