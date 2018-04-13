function [ dist] = smallest_dist(x0,x1,k)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
dist=(k*x1(1)-x1(2)+x0(2)-k*x0(1))/sqrt(k*k+1);

end

