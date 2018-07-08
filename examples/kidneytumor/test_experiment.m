
clear all;
clc;
% After all sub-models being trained, we can utilise them to segment our test images.
% An example here. Consuming V1 and H1 have been trained, we can get two segmentation
% results provided by these two sub-models. Then, we take the intersection
% of these two results as the final result of each image.
run(fullfile(fileparts(mfilename('fullpath')),...
  '..', '..', 'matlab', 'vl_setupnn.m')) ;
data_horizontal_Dir='data/kidney-baseline-simplenn/horizontal/';
data_vertical_Dir='data/kidney-baseline-simplenn/vertical/';
modelDir=strcat(data_horizontal_Dir,'H1.mat');
load('kidney_data\testpatch_horizontal.mat');%a struct variable being included, named images, which consist of three fields: data,labels,location.
load('kidney_data\train_mean__horizontal.mat');%
load('kidney_data\MR_test.mat');
load('kidney_data\edgeGR_test.mat');
[ prediction_H1 ] = test_Result_1(images_h,dataMean,'modelDir',modelDir);
[segment_result_H1] = test_Result_2(prediction_H1,MR_test);
clear images_h dataMean;
load('kidney_data\testpatch_vertical.mat');
load('kidney_data\train_mean_vertical.mat');%
modelDir=strcat(data_vertical_Dir,'V1.mat');
[ prediction_V1 ] = test_Result_1(images_v,dataMean,'modelDir',modelDir);
[segment_result_V1] = test_Result_2(prediction_V1, MR_test);
%%%%%%%%%%%%%%%%%%%%%%show the segmention result%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('kidney_data\RGB_test.mat');
[m,n,num]=size(MR_test);
intersect_result=uint8(zeros(m,n,num));
pro_result_H1=proprocess_seg1(segment_result_H1,m,n,num);
pro_result_V1=proprocess_seg1(segment_result_V1,m,n,num);
RGB_result_H1=proprocess_seg2(pro_result_H1,edgeGR_test);
RGB_result_V1=proprocess_seg2(pro_result_V1,edgeGR_test);
for i=1:num
    f1=find(pro_result_H1(:,:,i)>0);
    f2=find(pro_result_V1(:,:,i)>0);
    a=uint8(zeros(m,n));
    a(intersect(f1,f2))=255;
    intersect_result(:,:,i)=a;
end
RGB_intersect=proprocess_seg2(intersect_result,edgeGR_test);
s=4;
figure,
for i=1:4
    subplot(s,4,(i-1)*4+1),imshow(RGB_result_H1(:,:,:,i)); title('H1');%
    subplot(s,4,(i-1)*4+2),imshow(RGB_result_V1(:,:,:,i));title('V1');
    subplot(s,4,(i-1)*4+3),imshow(RGB_test(:,:,:,i));title('image');
    subplot(s,4,(i-1)*4+4),imshow(RGB_intersect(:,:,:,i));title('V1H1');
end
i=1;
figure,
for j=5:8
    subplot(s,4,(i-1)*4+1),imshow(RGB_result_H1(:,:,:,j)); title('H1');%
    subplot(s,4,(i-1)*4+2),imshow(RGB_result_V1(:,:,:,j));title('V1');
    subplot(s,4,(i-1)*4+3),imshow(RGB_test(:,:,:,j));title('image');
    subplot(s,4,(i-1)*4+4),imshow(RGB_intersect(:,:,:,j));title('V1H1');
    i=i+1;
end
i=1;
figure,
for j=9:12
    subplot(s,4,(i-1)*4+1),imshow(RGB_result_H1(:,:,:,j)); title('H1');%
    subplot(s,4,(i-1)*4+2),imshow(RGB_result_V1(:,:,:,j));title('V1');
    subplot(s,4,(i-1)*4+3),imshow(RGB_test(:,:,:,j));title('image');
    subplot(s,4,(i-1)*4+4),imshow(RGB_intersect(:,:,:,j));title('V1H1');
    i=i+1;
end

