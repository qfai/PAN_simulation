function [ F] = regifun3( param)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global pointU;
global pointL;
global B;

a=param(1);
b=param(2);
c=param(3);
d=param(4);
F=zeros(3+17,1);
F(1)=a^2+b^2-1;
F(2)=c^2+d^2-1;
transed=pointL*[1,0,0;0,a,-1*b;0,b,a]*[c,0,d;0,1,0;-d,0,c];
F(3:3+17)=(transed(:,3)-pointU(:,3)-B).^2;
end

