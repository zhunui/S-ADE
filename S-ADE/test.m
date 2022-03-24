%-------------------------------------清除缓存------------------------------------%
clear all;
close all;
clc;
%-------------------------------------读入图像------------------------------------%
mri = imread('c01_2.tif');
ct = imread('c01_1.tif');
%-------------------------------------参数设置------------------------------------%
num_iter = 30;    %设置最大迭代次数
delta_t = 1/8;    %设定为最大值
kappa = 20;       %or通过canny算子计算得到
a=1;
%kappa = function();
%num_iter = function();
% option = 1;     根据不同的源图像 计算不同的扩散函数
mri_base = zeros(256,256);
mri_detail = zeros(256,256);
ct_base = zeros(256,256);
ct_detail = zeros(256,256);
tic
%-------------------------------------图像拼接------------------------------------%
for i = 1:256
    for j = 257:512
        mri(i,j) = ct(i,j-256);%直接用mri表示拼接结果
    end
end
%---------------------------------------分解--------------------------------------%
[cN1,cS1,cW1,cE1,cNE1,cSE1,cSW1,cNW1,base] = anisodiff2D(mri,num_iter,delta_t,kappa,2,1);
figure,imshow(mri,[]),title('原图');
% figure,imshow(base,[]),title('base layer');
detail = double(mri)-base;
% figure,imshow(detail,[]),title('detaiil layer');
%---------------------------------------拆分--------------------------------------%
for i = 1:256
    for j = 1:256
        mri_base(i,j) = base(i,j);
        mri_detail(i,j) = detail(i,j);
        ct_base(i,j) = base(i,j+256);
        ct_detail(i,j) = detail(i,j+256);
    end
end
%---------------------------------------融合---------------------------------------%
image_detail = NSML(mri_detail,ct_detail,cN1,cS1,cW1,cE1,cNW1,cSE1,cNE1,cSW1,cN1,cS1,cW1,cE1,cNW1,cSE1,cNE1,cSW1);
% figure,imshow(image_detail,[]),title('fusion detail layer');
image_base = baserule(mri_base,ct_base);
% figure,imshow(image_base,[]),title('fusion base layer');
imagefusion = image_detail+image_base;
% figure,imshow(uint8(imagefusion)),title('fusion result');
%---------------------------------------校正---------------------------------------%
MAP = double(ct>220);
fusion = MAP.*double(ct)+(1-MAP).*imagefusion;
figure,imshow(uint8(fusion)),title('fusion result');
toc
