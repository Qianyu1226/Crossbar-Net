function [ RGB_r] = proprocess_seg2( result,edge_gr )
%RGB the bw segmentation result. edge_gr is the groundtruth. result is the
%segmentation result.
[m,n,num]=size(edge_gr);
RGB_r=uint8(zeros(m,n,3,num));
for i=1:num
[r,c]=find(edge_gr(:,:,i)>0);
a=result(:,:,i);
b=a;
f=length(r);
for j=1:f
    a(r(j)+5,c(j)+5)=255;
    b(r(j)+5,c(j)+5)=0;
end
RGB_r(:,:,1,i)=a;
    RGB_r(:,:,2,i)=b;
    RGB_r(:,:,3,i)=b;
end

