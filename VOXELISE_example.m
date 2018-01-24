
%Plot the original STL mesh:
figure
[stlcoords] = READ_stl('D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\whole.stl');
xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b');
axis equal

%Voxelise the STL:
[OUTPUTgrid] = VOXELISE(100,100,100,'D:\volume\volume_data\data\4_000009sunxia\c.Repairing1\whole.stl','xyz');

%Show the voxelised result:
figure;
subplot(1,3,1);
imagesc(squeeze(sum(OUTPUTgrid,1)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('Y-direction');
axis equal tight

subplot(1,3,2);
imagesc(squeeze(sum(OUTPUTgrid,2)));
colormap(gray(256));
xlabel('Z-direction');
ylabel('X-direction');
axis equal tight

subplot(1,3,3);
imagesc(squeeze(sum(OUTPUTgrid,3)));
colormap(gray(256));
xlabel('Y-direction');
ylabel('X-direction');
axis equal tight
%  f=fopen('tooth2.raw','wb');
% for i=1:100
% for j=1:100
% for k=1:100
% fwrite(f,OUTPUTgrid(i,j,k));
% end
% end
% end
% fclose(f);