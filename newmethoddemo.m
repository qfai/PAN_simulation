tooth_path='D:\volume\volume_data\data\4_000009sunxia\sunxia-cbctmesh\c.Repairing1\';
pan_point_file='sunxia_pan_point.mat';
paraimgname='sx.jpg';
Uaxes='U.axes';
Laxes='L.axes';
feafile='sunxia.fea';
%getpanpoint(paraimgname,pan_point_file);
newmethod(tooth_path,pan_point_file,paraimgname,feafile,Uaxes,Laxes);

% PAN_align_point.U=[U(1:6,:);U(8,:);U(10:15,:);U(17,:)];
% PAN_align_point.L=[L(1:6,:);L(8,:);L(10:15,:);L(17,:)];
% PAN_align_point.Lroot=Lroot;
% PAN_align_point.Uroot=Uroot;
% feafile='sx_one_point.fea';
% pan_point_file='sunxia_one_point.mat';
% save(pan_point_file,'-struct','PAN_align_point');
% newmethod_one_point(tooth_path,pan_point_file,paraimgname,feafile,Uaxes,Laxes);