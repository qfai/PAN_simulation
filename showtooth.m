function [] = showtooth( toothmesh )
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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

