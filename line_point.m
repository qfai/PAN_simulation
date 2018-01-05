function [ output ] = line_point( point0,k,requirepoint )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
if(requirepoint(1)<0)% need x
    output=requirepoint;
    output(1)=(output(2)-point0(2))/k+point0(1);
else
  output=requirepoint;
    output(2)=(output(1)-point0(1))*k+point0(2);  
end

end

