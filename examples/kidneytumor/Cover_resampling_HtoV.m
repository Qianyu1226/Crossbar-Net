function [images, retrain_patch_location ] = Cover_resampling_HtoV( wrongclass,location, GR_bw, MR_kidney )
%COVER_RESAMPLING % the wrong patches are taken out from the horizontal submodel, and the vertical patches 
    %are gotten according to the position in the original picture under the 
    %covering re-sampling strategy, so as to be 
    %sent to the new vertical sub-models for retraining. The misclassified index is generated 
    %by valuate_submodel.m; the position of the misclassified patch is recorded
    %at the same time, so that the data can be collected in the next round of retraining.
%images.location in data_horizontal.mat is a [number of patches 4] matrix. 
    %The first two cols of this matrix are the row and col of each patch center, 
    % the third col is the image which the patch belongs to.
    % the last col is the label of this patch.
%dis_segment is wrongclass.
% load('data_horizontal.mat');%images.location is provided.
% load('MR_kidney.mat');%the original images,
% load('GR_bw.mat');%bw image of ground truth,GR_bw is provided.

abstract=location(wrongclass,:);%pick out the misclassified patch.
newline=find(abstract(:,1)>65&abstract(:,1)<120&abstract(:,2)>65&abstract(:,2)<120);%the low request of row and col to re-sampling the vertical patches. 
newlocation=abstract(newline,:);%the pixel need to be resampled.
fileno=unique(newlocation(:,3));%the image need to be resampled, the misclassified horizontal patches belong to.
renum=zeros(length(fileno),2);
for i=1:length(fileno)%
    renum(i,1)=length(find(newlocation(:,3)==fileno(i)&newlocation(:,4)==1));%number of tumor case.
    renum(i,2)=length(find(newlocation(:,3)==fileno(i)&newlocation(:,4)==0));%number of background case£¬should equal to the number of tumor case when re-sampling.
end 
sh=100;%height of vertical patch.
sw=20;%width
ks=0;
s1=0;
s2=0;
mar=sw/2;
po_data=[];
    po_label=[];
    ne_data=[];
    ne_label=[];
    c=[];
    cleft=[];
    cright=[];
 num=1;
 interval=8;%the interval when resampling.
 numloc=1;%row of each misclassifed pixel.
%%% covering re-sampling strategy
 for w=1:1:length(fileno)
          img1=GR_bw(:,:,w);
          img2=MR_kidney(:,:,w);
          s1=renum(w,1)+renum(w,2);
          s2=renum(w,1)-renum(w,2);
          picenum1=1;
          picenum2=1;
          for i=1:s1
             %sampling vertical patch from horizontal patch.
                  for j=-sh/2:interval:sh/2-1
                      
                      c=img2(newlocation(numloc,1)-sh/2:newlocation(numloc,1)+sh/2-1,newlocation(numloc,2)+j-sw/2:newlocation(numloc,2)+j+sw/2-1);
                      cleft=img2(newlocation(numloc,1)-sh/2+mar:newlocation(numloc,1)+sh/2+mar-1,newlocation(numloc,2)+j+3-sw/2:newlocation(numloc,2)+j+3+sw/2-1);
                      cright=img2(newlocation(numloc,1)-sh/2-mar:newlocation(numloc,1)+sh/2-mar-1,newlocation(numloc,2)+j+6-sw/2:newlocation(numloc,2)+j+6+sw/2-1);
                    
                      if img1(newlocation(numloc,1),newlocation(numloc,2)+j)>0
                          po_data(:,:,picenum1)=c;%tumor case.
                          po_label(picenum1)=1;
                          po_local(picenum1,:)=[double(newlocation(numloc,1)) double(newlocation(numloc,2)+j) double(fileno(w)) 1];
                          newlocation(numloc,2)
                          picenum1=picenum1+1;
                      else
                          ne_data(:,:,picenum2)=c;%groundback case
                          ne_label(picenum2)=0;
                          ne_local(picenum2,:)=[double(newlocation(numloc,1)) double(newlocation(numloc,2)+j) double(fileno(w)) 0];
                          picenum2=picenum2+1;
                      end
                      if img1(newlocation(numloc,1)+mar,newlocation(numloc,2)+j+3)>0
                          po_data(:,:,picenum1)=cleft;%
                          po_label(picenum1)=1;
                          po_local(picenum1,:)=[double(newlocation(numloc,1)+mar) double(newlocation(numloc,2)+j+3) double(fileno(w)) 1];
                          picenum1=picenum1+1;
                      else
                          ne_data(:,:,picenum2)=cleft;%
                          ne_label(picenum2)=0;
                          ne_local(picenum2,:)=[double(newlocation(numloc,1)+mar) double(newlocation(numloc,2)+j+3) double(fileno(w)) 0];
                          picenum2=picenum2+1;
                      end
                      if img1(newlocation(numloc,1)-mar,newlocation(numloc,2)+j+6)>0
                          po_data(:,:,picenum1)=cright;%
                          po_label(picenum1)=1;
                          po_local(picenum1,:)=[double(newlocation(numloc,1)-mar) double(newlocation(numloc,2)+j+6) double(fileno(w)) 1];
                          picenum1=picenum1+1;
                      else
                          ne_data(:,:,picenum2)=cright;%
                          ne_label(picenum2)=0;
                          ne_local(picenum2,:)=[double(newlocation(numloc,1)-mar) double(newlocation(numloc,2)+j+6) double(fileno(w)) 0];
                          picenum2=picenum2+1;
                      end
                  end
              numloc=numloc+1;%   
           end
          %  
   picenum2=picenum2-1;
   picenum1=picenum1-1;
    %balance the kidney tumor patches and background patches.
     p=randperm(picenum1);
     q=randperm(picenum2);
   if picenum1>1
     if picenum2>picenum1%the number of background patches is large than the tumor case.
         images.data(:,:,1,num:num+picenum1-1)=single(po_data(:,:,1:picenum1));%-1-1
         images.labels(num:num+picenum1-1)=po_label(1:picenum1);
         retrain_patch_location(num:num+picenum1-1,:)=po_local(1:picenum1,:);%
         num=num+picenum1;
         tempdata=ne_data(:,:,q);
         templabel=ne_label(q);
         images.data(:,:,1,num:num+picenum1-1)=single(tempdata(:,:,1:picenum1));%
         images.labels(num:num+picenum1-1)=templabel(1:picenum1);
         templocal=ne_local(q,:);%¸øpatch¶¨Î»
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
          templocal=po_local(p,:);%
          retrain_patch_location(num:num+picenum2-1,:)=templocal(1:picenum2,:);
         num=num+picenum2;
     end
   end
 end

 fprintf('total number%d:\n ',num-1);
 a=length(find(images.labels(:)~=0))
 num-a-1
%   save -v7.3 retraindata_HtoV images
%   save retrain_location_HtoV retrain_patch_location


end

