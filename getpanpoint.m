function [  ] = getpanpoint( paraimgname ,pan_filename)
% order should be LL1->LLR
%   此处显示详细说明
imshow(paraimgname)
hold on
[lx,ly]=ginput(18);
[ux,uy]=ginput(18);
scatter(lx,ly)
scatter(ux,uy)
PAN_align_point.U=[ux,uy];
PAN_align_point.L=[lx,ly];
[rootx,rooty]=ginput(18);
scatter(rootx,rooty)
PAN_align_point.Lroot=[rootx,rooty];
[rootx,rooty]=ginput(18);
scatter(rootx,rooty)
PAN_align_point.Uroot=[rootx,rooty];
save(pam_filename,'-struct',PAN_align_point);


end

