function img_base = baserule(I1,I2)
%BASERULE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
m = size(I1,1); 
n = size(I1,2);
img_base = zeros(m,n);

for i = 1:m
    for j = 1:n
        if I1(i,j)>=I2(i,j)
            img_base(i,j) = I1(i,j);
        else
            img_base(i,j) = I2(i,j);
        end
    end
    
end

