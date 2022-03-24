%-------------------------------------�������------------------------------------%
clear all;
close all;
clc;
%-------------------------------------����ͼ��------------------------------------%
mri = imread('c01_2.tif');
ct = imread('c01_1.tif');
%-------------------------------------��������------------------------------------%
num_iter = 30;    %��������������
delta_t = 1/8;    %�趨Ϊ���ֵ
kappa = 20;       %orͨ��canny���Ӽ���õ�
a=1;
%kappa = function();
%num_iter = function();
% option = 1;     ���ݲ�ͬ��Դͼ�� ���㲻ͬ����ɢ����
mri_base = zeros(256,256);
mri_detail = zeros(256,256);
ct_base = zeros(256,256);
ct_detail = zeros(256,256);
tic
%-------------------------------------ͼ��ƴ��------------------------------------%
for i = 1:256
    for j = 257:512
        mri(i,j) = ct(i,j-256);%ֱ����mri��ʾƴ�ӽ��
    end
end
%---------------------------------------�ֽ�--------------------------------------%
[cN1,cS1,cW1,cE1,cNE1,cSE1,cSW1,cNW1,base] = anisodiff2D(mri,num_iter,delta_t,kappa,2,1);
figure,imshow(mri,[]),title('ԭͼ');
% figure,imshow(base,[]),title('base layer');
detail = double(mri)-base;
% figure,imshow(detail,[]),title('detaiil layer');
%---------------------------------------���--------------------------------------%
for i = 1:256
    for j = 1:256
        mri_base(i,j) = base(i,j);
        mri_detail(i,j) = detail(i,j);
        ct_base(i,j) = base(i,j+256);
        ct_detail(i,j) = detail(i,j+256);
    end
end
%---------------------------------------�ں�---------------------------------------%
image_detail = NSML(mri_detail,ct_detail,cN1,cS1,cW1,cE1,cNW1,cSE1,cNE1,cSW1,cN1,cS1,cW1,cE1,cNW1,cSE1,cNE1,cSW1);
% figure,imshow(image_detail,[]),title('fusion detail layer');
image_base = baserule(mri_base,ct_base);
% figure,imshow(image_base,[]),title('fusion base layer');
imagefusion = image_detail+image_base;
% figure,imshow(uint8(imagefusion)),title('fusion result');
%---------------------------------------У��---------------------------------------%
MAP = double(ct>220);
fusion = MAP.*double(ct)+(1-MAP).*imagefusion;
figure,imshow(uint8(fusion)),title('fusion result');
toc
