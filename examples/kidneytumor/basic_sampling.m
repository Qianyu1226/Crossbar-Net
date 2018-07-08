clear all;

load('train_matrix.mat');
load('train_gr.mat');
load('edgeGR_train.mat');
load('Center_train.mat');
sh=20;
sw=100;
[m,n,num]=size(train_gr);
tumor=uint8(zeros(m,n,num));
num_patch=1;%number of patches
for i=1:num
    i
    img=train_matrix(:,:,i);
    gr=train_gr(:,:,i);
    b=uint8(zeros(m,n));
    a=edgeGR_train(:,:,i);
    %imshow(a);
    %%%%%%%%%%inside the tumor, sample uniformly%%%%%%%%
    mindis=floor(min(center(i,3:6))*0.6);
    r=center(i,1)-mindis:6:center(i,1)+mindis;
    c=center(i,2)-mindis:6:center(i,2)+mindis;
    [nr,nc]=meshgrid(r,c);
    nrc=[nr(:),nc(:)];
    b(nrc(:,1),nrc(:,2))=255;
    %%%%%%%%%%nearby the edge, sampling tensely, and far from the edge, sparsely %%%%%%%%%%
    f=find(a>0);
    temp=f(randperm(length(f),floor(length(f)*0.4)));
    b(temp)=255;
    right=f;
    left=f;
    top=f;
    down=f;
    percent=0.15;
    %m=m-4;
    for j=1:6
        right=right+j*m;
        temp=right(randperm(length(right),floor(length(right)*(percent-(j-1)*0.015))));
        b(temp)=255;
        rtop=right-j;
        temp=rtop(randperm(length(rtop),floor(length(rtop)*(percent-(j-1)*0.015))));
        b(temp)=255;
        rdown=right+j;
        temp=rdown(randperm(length(rdown),floor(length(rdown)*(percent-(j-1)*0.015))));
        b(temp)=255;
        left=left-j*m;
        temp=left(randperm(length(left),floor(length(left)*(percent-(j-1)*0.015))));
        b(temp)=255;
        ldown=left+j;
        temp=ldown(randperm(length(ldown),floor(length(ldown)*(percent-(j-1)*0.015))));
        b(temp)=255;
        ltop=left-j;
        temp=ltop(randperm(length(ltop),floor(length(ltop)*(percent-(j-1)*0.015))));
        b(temp)=255;
        top=top-j;
        temp=top(randperm(length(top),floor(length(top)*(percent-(j-1)*0.015))));
        b(temp)=255;
        down=down+j;
        temp=down(randperm(length(down),floor(length(down)*(percent-(j-1)*0.015))));
        b(temp)=255;
    end
   tumor(:,:,i)=b;
   f1=find(b);
   f2=find(gr); 
   f12=intersect(f1,f2);
   f_tumor=f12;
   le12=length(f12)
   f3=setdiff(f1,f12);
   f_bg=f3;
   le3=length(f3)
   if le12>le3    %if the number of tumor is larger than that of background
       f_tumor=f12(randperm(le12,le3));
   end
   if le12<le3    %if the number of tumor is smaller than that of background
       f_bg=f3(randperm(le3,le12));
   end
   col=floor(f_tumor/m)+1;
   row=f_tumor-(col-1)*m;
   for j=1:length(f_tumor)
       images.data(:,:,1,num_patch)=img(row(j)-sh/2:row(j)+sh/2-1,col(j)-sw/2:col(j)+sw/2-1);
       images.labels(1,num_patch)=1;
       images.location(num_patch,:)=[row(j) col(j) 1 i];
       num_patch=num_patch+1;
   end
    col=floor(f_bg/m)+1;
    row=f_bg-(col-1)*m;
   for j=1:length(f_bg)
       images.data(:,:,1,num_patch)=img(row(j)-sh/2:row(j)+sh/2-1,col(j)-sw/2:col(j)+sw/2-1);
       images.labels(1,num_patch)=0;
       images.location(num_patch,:)=[row(j) col(j) 0 i];
       num_patch=num_patch+1;
   end
end
%length(images.labels)
f=find(images.labels);
length(f)
f=find(images.labels==0);
length(f)
%figure,imshow(tumor(:,:,i));