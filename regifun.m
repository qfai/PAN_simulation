function [ F] = regifun( param)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
global pointU;
global B;
scale=12.5;
%param(1)=21.8911;
%scale=param(1);
a=param(2);
b=param(3);
c=param(4);
d=param(5);
F=zeros(3+17,1);
F(1)=1000000*(a^2+b^2-1);
F(2)=1000000*(c^2+d^2-1);
transed=pointU*scale*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
F(3:3+17)=(transed(:,3)-transed(1,3)-B).^2;
end

