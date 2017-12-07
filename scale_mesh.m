function [mesh,center] = scale_mesh(mesh,scale,varargin )
%mesh is n*3 
%   scale 1*3
if nargin==3
    center=varargin{1};
else
    center=sum(mesh)/size(mesh,1);
end
mesh=mesh-repmat(center,[size(mesh,1),1]);
mesh=mesh.*repmat(scale,[size(mesh,1),1]);
mesh=mesh+repmat(center,[size(mesh,1),1]);
end

