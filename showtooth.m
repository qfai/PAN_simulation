function [] = showtooth( toothmesh )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
figure;
hold on;
for i=1:14
    pcshow(pointCloud(toothmesh.U{i}));
end
for i=1:14
    pcshow(pointCloud(toothmesh.L{i}));
end    
hold off;

end

