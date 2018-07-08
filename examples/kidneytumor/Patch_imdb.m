close all;
clear all;
clc;
%Transform the data into the imdb form for training.
load('datas\data_horizontal.mat');%data_horizontal is a file, including one varable: images.
%The images is a construct variable, consisting of three fields: data, labels, location. 
% images.data is an uint8 matrix including all training patches with the size [20 100 1 580000],and 580,000 is the number of patches. 
% images.labels is a double matrix with the size [1 580000],recording the labels of patches, 0 is background and 1 is kidney tumor. 
% images.location is a double matrix with the size [580000 4], the four cols are the center pixel's row, col,
% label and which image the pixel belongs to. It will be used in the funtction
% Cover_resampling_HtoV and Cover_resampling_VtoH.

%Positive and negative examples each account for half of the total. The
%vertical patch is set in the same way with the horizontal patch.

dataMean=mean(squeeze(images.data(:,:,1,1:453972)),3);% dataMean is average of train patches. 464000 is the number of training set.
images.data =single(bsxfun(@minus, images.data, dataMean));%
set=[ones(1,453972),3*ones(1,92812)];%116000 is the number of valuation set.
images.data_mean = dataMean;%
images.labels=images.labels+1;%the label is changed to 1 and 2
images.set = set;
meta.sets = {'train', 'val', 'test'} ;%
meta.classes = arrayfun(@(x)sprintf('%d',x),0:1,'uniformoutput',false) ;%
%save the imdb_horizontal.mat under the path data\horizontal, then rename it as imdb.mat.
% Processing the imdb_vertical.mat in the same way.
save -v7.3 imdb__horizontal images meta 
save train_mean__horizontal dataMean

