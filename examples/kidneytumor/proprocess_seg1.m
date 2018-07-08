function [ process_result] = proprocess_seg( result,m,n,num )
%To proprocess the segment result. m,n,num are size of test matrix.
se = strel('disk',3);
process_result=uint8(zeros(m,n,num));
for i=1:num
    t=uint8(result(:,:,i)); 
    %figure,subplot(2,3,1),imshow(t);
    t=imdilate(t,se);
    t=imerode(t,se);
     t=imfill(t,'holes');
     %subplot(2,3,2),imshow(t);
     image_bw=maxConnectDomain(t);
     f=find(image_bw==1);
     temp=uint8(zeros(m,n));
     temp(f)=255;
     process_result(:,:,i)=temp;
%      temp2=MR_test(:,:,i);
%      temp3=temp;
%      temp3(f)=temp2(f);
%      subplot(2,3,3),imshow(temp);
%      subplot(2,3,4),imshow(temp3);
%      subplot(2,3,5),imshow(MR_test(:,:,i));
    
end


end

