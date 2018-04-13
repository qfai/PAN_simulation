function [ x,y,dy ] = get_nearest_point( point,curve)
%assume the curve is specified
%   此处显示详细说明
% x=point(1);
% lamda=0.1;
% dx=2*(curve.a*x*x*x*x+curve.b*x*x*x+curve.d*x+curve.e-point(2))*(4*curve.a*x*x*x+3*curve.b*x*x+curve.d)+2*(x-point(1));
% while(dx>0.2)
%    x=x-dx*lamda;
%    dx=2*(curve.a*x*x*x*x+curve.b*x*x*x+curve.d*x+curve.e-point(2))*(4*curve.a*x*x*x+3*curve.b*x*x+curve.d)+2*(x-point(1));
%     
% end
% y=curve.a*x*x*x*x+curve.b*x*x*x+curve.d*x+curve.e;
%  dy=4*curve.a*x*x*x+3*curve.b*x*x+curve.d;
x1(1)=point(1);
i=x1(1);
x1(2)=curve.a*i*i*i*i+curve.b*i*i*i+curve.d*i+curve.e;
dy=4*curve.a*i*i*i+3*curve.b*i*i+curve.d;
x2(1)=( dy*(point(2)-x1(2))+dy*dy*x1(1)+point(1))/(dy*dy+1);
x2(2)=dy*(x2(1)-x1(1))+x1(2);
x3(1)=x2(1);
i=x3(1);
x3(2)=curve.a*i*i*i*i+curve.b*i*i*i+curve.d*i+curve.e;
while(norm(x1-x3,2)>=1)
    point=x2;
x1(1)=point(1);
x1(2)=curve.a*i*i*i*i+curve.b*i*i*i+curve.d*i+curve.e;
dy=4*curve.a*i*i*i+3*curve.b*i*i+curve.d;
x2(1)=( dy*(point(2)-x1(2))+dy*dy*x1(1)+point(1))/(dy*dy+1);
x2(2)=dy*(x2(1)-x1(1))+x1(2);
x3(1)=x2(1);
i=x3(1);
x3(2)=curve.a*i*i*i*i+curve.b*i*i*i+curve.d*i+curve.e;
end
 x=x3(1);
 y=x3(2);
 i=x;
 dy=4*curve.a*i*i*i+3*curve.b*i*i+curve.d;
end

%%
%test a point in the curve
% point(1)=5;
% i=5;
% point(2)=curve2.a*i*i*i*i+curve2.b*i*i*i+curve2.d*i+curve2.e;
% plot(curve2,'m');hold on ;
% scatter(point(1),point(2));
% [x,y,dy]=get_nearest_point(point,curve2);
% scatter(x,y);
% test a point below the curve and draw it 
% point=[200,200];
%  [x,y,dy]=get_nearest_point(point,curve2);
% plot(curve2,'m');hold on ;
% scatter(point(1),point(2));
% scatter(x,y,'r*'