function [ index ] = transfor_axes( str )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
index=1;
if(str(2)=='L')
    index=3*7+1;

index=index+3*(str2num(str(3))-1);
else
    index=index+3*(7-str2num(str(3)));
end
end

