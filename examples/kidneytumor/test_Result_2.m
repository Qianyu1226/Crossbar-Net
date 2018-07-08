function [segment_result] = test_Result_2( prediction, MR_test)
% load('prediction_horizontal_1.mat');% provided by testResult1.m
% load('MR_test.mat')%the original test images.
temp2=prediction;
filenum=unique(temp2(:,4));%the number of test images
pointlabel=cell(length(filenum),1);
[m n]=size(MR_test(:,:,1));
 for i=1:length(filenum)   
     pointnum=find(temp2(:,4)==filenum(i));%the number of tested pixels in each image
     pointlabel{i,1}=temp2(pointnum,:);%label of each pixel of each image.
     point_va1(:,:,i)=uint8(MR_test(:,:,i));%the corresponding test image.
 end
 segment_result=zeros(m,n,length(filenum));
 for i=1:length(filenum) 
    p1=find(pointlabel{i,1}(:,1)==2);
     for j=1:length(p1)%segmentation result of each image
         segment_result(pointlabel{i,1}(p1(j),2),pointlabel{i,1}(p1(j),3),i)=point_va1(pointlabel{i,1}(p1(j),2),pointlabel{i,1}(p1(j),3),i);
     end
 end
% save test_network segment_result point_va1

end

