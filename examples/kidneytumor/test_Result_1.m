function [ prediction ] = test_Result_1( images,datamean, varargin)
%test the trained sub-model,remember all test result of each patch.
%images.location is a matrix with the size [number of patches,3] saved in test_horizontal.mat. 
    %The first two cols of this matrix are the row and col of each patch center, 
    %and the last col is the image which the patch belongs to.
%import all data.
%load('test_horizontal.mat');%a struct variable, named images, is included, which consist of three fields: data,labels,location.
%load('train_mean.mat');%horizontal or vertical datamean,respectively.
run(fullfile(fileparts(mfilename('fullpath')),...
  '..', '..', 'matlab', 'vl_setupnn.m')) ;
opts.modelDir='data/kidney-baseline-simplenn/horizontal/net-epoch-20.mat'; 
%the sub-model to be fine-tuned or tested.
[opts, varargin] = vl_argparse(opts, varargin);
 opts.fullmodelDir=fullfile(vl_rootnn,opts.modelDir);
 load(opts.fullmodelDir);
%change the last layer of the cnn into softmax
net.layers{1,end}.type='softmax';

trainmean=single(datamean);
    m=size(images.location,1);%number of patches
    prediction=zeros(m,4);%
    scores=[];
    res=[];
    for i=1:m
        im_=single(images.data(:,:,1,i));
        im_=im_-trainmean;
        res=vl_simplenn(net,im_);
        scores=squeeze(gather(res(end).x));
        [bestscore, best]=max(scores);
        prediction(i,1)=best;%the prediction label of pixel of each patch
        prediction(i,2:4)=images.location(i,:);
    end
%save prediction prediction;

end

