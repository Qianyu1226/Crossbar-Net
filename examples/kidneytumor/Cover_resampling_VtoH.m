function [ images, retrain_patch_location ] = Cover_resampling_VtoH( wrongclass,location, GR_bw, MR_kidney )
abstract=location(wrongclass,:);%pick out the misclassified patch.
newline=find(abstract(:,1)>65&abstract(:,1)<120&abstract(:,2)>65&abstract(:,2)<120);%the low request of row and col to re-sampling the vertical patches. 
newlocation=abstract(newline,:);%the pixel need to be resampled.
fileno=unique(newlocation(:,3));%the image need to be resampled, the misclassified horizontal patches belong to.
renum=zeros(size(fileno));

renum=zeros(size(fileno),2);

for i=1:length(fileno)
    renum(i,1)=length(find(newlocation(:,3)==fileno(i)&newlocation(:,4)==1));
    renum(i,2)=length(find(newlocation(:,3)==fileno(i)&newlocation(:,4)==0));%
end 
sh=20;%height,
sw=100;%width
ks=0;
s1=0;
s2=0;
mar=sh/2;
po_data=[];
    po_label=[];
    ne_data=[];
    ne_label=[];
    c=[];
    cleft=[];
    cright=[];
 num=1;
 interval=8;%the interval when resampling.
 numloc=1;
 for w=1:length(fileno)
     
         img1=GR_bw(:,:,w);
          img2=MR_kidney(:,:,w);
          s1=renum(w,1)+renum(w,2);
          s2=renum(w,1)-renum(w,2);
          picenum1=1;
          picenum2=1;
          for i=1:s1
            %resampling horizontal patch based on vertical patch
                  for j=-sw/2:interval:sw/2-1
                      %
                      c=img2(newlocation(numloc,1)+j-sh/2:newlocation(numloc,1)+j+sh/2-1,newlocation(numloc,2)-sw/2:newlocation(numloc,2)+sw/2-1);
                      cleft=img2(newlocation(numloc,1)+j+3-sh/2:newlocation(numloc,1)+j+3+sh/2-1,newlocation(numloc,2)-mar-sw/2:newlocation(numloc,2)-mar+sw/2-1);
                      cright=img2(newlocation(numloc,1)+j+6-sh/2:newlocation(numloc,1)+j+6+sh/2-1,newlocation(numloc,2)+mar-sw/2:newlocation(numloc,2)+mar+sw/2-1);
                      if img1(newlocation(numloc,1)+j,newlocation(numloc,2))>0
                          po_data(:,:,picenum1)=c;%
                          po_label(picenum1)=1;
                          po_local(picenum1,:)=[double(newlocation(numloc,1)+j) double(newlocation(numloc,2)) double(fileno(w)) 1];
                          %the patch locates at the fileno(w) image, row is newlocation(numloc,1)+j, col is newlocation(numloc,2)
                          picenum1=picenum1+1;
                      else
                          ne_data(:,:,picenum2)=c;
                          ne_label(picenum2)=0;
                          ne_local(picenum2,:)=[double(newlocation(numloc,1)+j) double(newlocation(numloc,2)) double(fileno(w)) 0];
                          picenum2=picenum2+1;
                      end
                      if img1(newlocation(numloc,1)+j+3,newlocation(numloc,2)-mar)>0
                          po_data(:,:,picenum1)=cleft;
                          po_label(picenum1)=1;
                          po_local(picenum1,:)=[double(newlocation(numloc,1)+j+3) double(newlocation(numloc,2)-mar) double(fileno(w)) 1];
                          picenum1=picenum1+1;
                      else
                          ne_data(:,:,picenum2)=cleft;
                          ne_label(picenum2)=0;
                          ne_local(picenum2,:)=[double(newlocation(numloc,1)+j+3) double(newlocation(numloc,2)-mar) double(fileno(w)) 0];
                          picenum2=picenum2+1;
                      end
                      if img1(newlocation(numloc,1)+j+6,newlocation(numloc,2)+mar)>0
                          po_data(:,:,picenum1)=cright;
                          po_label(picenum1)=1;
                          po_local(picenum1,:)=[double(newlocation(numloc,1)+j+6) double(newlocation(numloc,2)+mar) double(fileno(w)) 1];
                          picenum1=picenum1+1;
                      else
                          ne_data(:,:,picenum2)=cright;
                          ne_label(picenum2)=0;
                          ne_local(picenum2,:)=[double(newlocation(numloc,1)+j+6) double(newlocation(numloc,2)+mar) double(fileno(w)) 0];
                          picenum2=picenum2+1;
                      end
                  end
              numloc=numloc+1;%recording the change of index array      
           end
         
   picenum2=picenum2-1;
   picenum1=picenum1-1;
    % balance 
     p=randperm(picenum1);
     q=randperm(picenum2);
   if picenum1>1
     if picenum2>picenum1
         images.data(:,:,1,num:num+picenum1-1)=single(po_data(:,:,1:picenum1));%-1-1
         images.labels(num:num+picenum1-1)=po_label(1:picenum1);
         retrain_patch_location(num:num+picenum1-1,:)=po_local(1:picenum1,:);
         num=num+picenum1;
         tempdata=ne_data(:,:,q);
         templabel=ne_label(q);
         images.data(:,:,1,num:num+picenum1-1)=single(tempdata(:,:,1:picenum1));
         images.labels(num:num+picenum1-1)=templabel(1:picenum1);
         templocal=ne_local(q,:);
         retrain_patch_location(num:num+picenum1-1,:)=templocal(1:picenum1,:);
         num=num+picenum1;
     else
         images.data(:,:,1,num:num+picenum2-1)=single(ne_data(:,:,1:picenum2));
         images.labels(num:num+picenum2-1)=ne_label(1:picenum2);
         retrain_patch_location(num:num+picenum2-1,:)=ne_local(1:picenum2,:);%
         num=num+picenum2;
          tempdata=po_data(:,:,p);
         templabel=po_label(p);
         images.data(:,:,1,num:num+picenum2-1)=single(tempdata(:,:,1:picenum2));
         images.labels(num:num+picenum2-1)=templabel(1:picenum2);
          templocal=po_local(p,:);
          retrain_patch_location(num:num+picenum2-1,:)=templocal(1:picenum2,:);
         num=num+picenum2;
     end
   end
 end

 fprintf('×ÜÊýÄ¿%d:\n ',num-1);
 a=length(find(images.labels(:)~=0))
 num-a-1
 % save -v7.3 retraindata_100to20 images
 % save retrainlocation100to20 retrain_patch_location

end

