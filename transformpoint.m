function [ point ] = transformpoint(point,tmp,scale )
%2d
%   point is n*m(m=2)
for i=1:size(point,1)
    point(i,:)=floor((point(i,:)-[tmp.XLimits(1),tmp.YLimits(1)])*scale+[1,1]);

end

