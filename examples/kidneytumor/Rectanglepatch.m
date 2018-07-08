%%%%%%%%%%%%%%%%%% Basic sampling strategy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;%
% Files1 = dir('train\*.bmp');%标记图
% Files2 = dir('train\*.jpg');%原图
% LengthFiles = length(Files1);
% [m,n]=size(imread(strcat('train\',Files1(1).name)));
load('datas\train_matrix.mat');
load('datas\train_gr.mat');
load ('datas\Center_train.mat');
[m,n,LengthFiles]=size(train_gr);

sh=20;%height
sw=100;%width
num=1;
dis=15;%离中心点多大范围内找负例
randomnumber=10;%随机在四周找负例的个数

po_data=[];
    po_label=[];
    ne_data=[];
    ne_label=[];
    po_local=[];
    ne_local=[];
for w=1:LengthFiles%1-LengthFiles-
  w
        img1=train_gr(:,:,w);
         img2=train_matrix(:,:,w);
     picenum1=1;
     for i=sh/2:4:m-sh/2  
         for j=sw/2:4:n-sw/2
            if img1(i,j)>0
                c=img2(i-sh/2+1:i+sh/2,j-sw/2+1:j+sw/2);
                po_data(:,:,picenum1)=c;
                po_label(picenum1)=1;
                po_local(picenum1,:)=[i j w 1];%表明该patch位于第w幅图像的第i行第j
                 picenum1=picenum1+1;
            end
         end
     end
     fprintf('第%d个正例数%d:\n ',w,picenum1);
     
     %%%%%%%在dis范围内找负例，另外randomnumber个负例要远处周边随机找，最后正负例个数要相等
     
     left=center(w,2)-center(w,3)-dis-10;
     if left<sw/2
         left=sw/2;
     end
     right=center(w,2)+center(w,4)+dis+10;
     if right>n-sw/2
         right=n-sw/2-1;
     end
     top=center(w,1)-center(w,5)-dis-10;
     if top<sh/2
         top=sh/2;
     end
     down=center(w,1)+center(w,6)+dis+10;
     if down>m-sh/2
         down=m-sh/2-1;
     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%在dis范围内找负例%%%%%%%%%%%%%%%%
      picenum2=1;
     for i=top:4:down  %%%%%%%%%%隔几个取一个
         for j=left:5:right
            if img1(i,j)==0
                c=img2(i-sh/2+1:i+sh/2,j-sw/2+1:j+sw/2);
                ne_data(:,:,picenum2)=uint8(c);
                ne_label(picenum2)=0;
                ne_local(picenum2,:)=[double(i) double(j) double(w) double(0)];%表明该patch位于第w幅图像的第i行第j列
%不需要记位置时可以去掉
                picenum2=picenum2+1;
            end
         end
     end
    fprintf('第%d个负例数%d:\n ',w,picenum2);
    picenum2=picenum2-1;
    picenum1=picenum1-1;
    %正负例平衡
     p=randperm(picenum1);
     q=randperm(picenum2);

     if picenum2+randomnumber>picenum1%负例多于正例，随机减负例
         images.data(:,:,1,num:num+picenum1-1)=single(po_data(:,:,1:picenum1));%-1-1
         images.labels(num:num+picenum1-1)=po_label(1:picenum1);
         images.location(num:num+picenum1-1,:)=po_local(1:picenum1,:);%给patch定位，%不需要记位置时可以去掉
   
         num=num+picenum1;
         tempdata=ne_data(:,:,q);
         templabel=ne_label(q);
         
         images.data(:,:,1,num:num+picenum1-randomnumber-1)=single(tempdata(:,:,1:picenum1-randomnumber));%-30-1-1
         images.labels(num:num+picenum1-randomnumber-1)=templabel(1:picenum1-randomnumber);
          templocal=ne_local(q,:);%给patch定位%不需要记位置时可以去掉
          images.location(num:num+picenum1-randomnumber-1,:)=templocal(1:picenum1-randomnumber,:);%%不需要记位置时可以去掉
 
         num=num+picenum1-randomnumber;
         
     else%正例多于负例，随机减正例，但一般不会遇到
         images.data(:,:,1,num:num+picenum2-1)=single(ne_data(:,:,1:picenum2));
         images.labels(num:num+picenum2-1)=ne_label(1:picenum2);
         images.location(num:num+picenum2-1,:)=ne_local(1:picenum2,:);%给patch定位
  
         num=num+picenum2;
          tempdata=po_data(:,:,p);
         templabel=po_label(p);
        
         images.data(:,:,1,num:num+picenum2-1+randomnumber)=single(tempdata(:,:,1:picenum2+randomnumber));
         images.labels(num:num+picenum2-1+randomnumber)=templabel(1:picenum2+randomnumber);
          templocal=po_local(p,:);%给patch定位%不需要记位置时可以去掉
          images.location(num:num+picenum2-1+randomnumber,:)=templocal(1:picenum2+randomnumber,:);%不需要记位置时可以去掉
       
         num=num+picenum2+randomnumber;
     end
     %%%%%%%%%%%%%%%%%锟斤拷锟杰憋拷远锟斤拷锟斤拷锟饺★拷锟斤拷锟?%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     ks=0;

     for j=1:400%在外围找randomnumber个
         p=round(rand(1,1)*150+2);%70 130对应10sh*64sw，是64 10时反过来;150 90：10020
         q=round(rand(1,1)*150+2);        
        temp=img1(q:q+sh-1,p:p+sw-1);
        if sum((sum(temp))')==0
            images.data(:,:,1,num)=single(img2(q:q+sh-1,p:p+sw-1));%锟斤拷锟斤拷
            images.labels(num)=0;
            images.location(num,:)=[double(floor((2*q+sh-1)/2)) double(floor((2*p+sw-1)/2)) double(w) double(0)];%给patch定位
            num=num+1;
            ks=ks+1;
            if ks==randomnumber
                break;
            end
        end
     end
 %    a(w,3)=ks;
     % fprintf('锟斤拷%d锟斤拷锟斤拷锟斤拷锟斤拷锟斤拷%d:\n ',w,num);
end
location_train=images.location;
 fprintf('总数目%d:\n ',num-1);
 a=length(find(images.labels(:)~=0))
 num-a-1
    save -v7.3 data_horizontal images
    save location_train_horizontal location_train