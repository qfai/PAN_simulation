function [ output ] = Get_feature_point( feature,index )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if(index<=5)
    output=feature(index,:);
elseif(index>7&&index<=12)
        output=feature(index+2,:);
elseif(index==13)
    output=feature(index+2:index+3,:);
elseif(index==14)
    output=feature(index+3:index+4,:);
elseif(index==6)
    output=feature(index:index+1,:);
elseif(index==7)
    output=feature(index+1:index+2,:);
    
end

end

