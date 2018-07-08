function [wrongclass ] = sub_model_valuate(images,datamean, varargin )
% This function is to pick the misclassified patch on the horizontal(vertical) data set.
    % The serial number is stored in the wrongclass, so that it can be
    % returned to the original image and than resampled under the covering re-sampling strategy.
    run(fullfile(fileparts(mfilename('fullpath')),...
  '..', '..', 'matlab', 'vl_setupnn.m')) ;
    opts.modelDir='data/kidney-baseline-simplenn/horizontal/net-epoch-20.mat';   
%     opts.dataDir='data/kidney-baseline-simplenn/horizontal/data_horizontal.mat';
%     opts.meanDir='data/kidney-baseline-simplenn/horizontal/train_mean_horizontal.mat';
    [opts, varargin] = vl_argparse(opts, varargin);
     opts.fullmodelDir=fullfile(vl_rootnn,opts.modelDir);
     %     opts.fulldataDir=fullfile(vl_rootnn,opts.dataDir);
     %     opts.fulldataDir=fullfile(vl_rootnn,opts.meanDir);
     [opts, varargin] = vl_argparse(opts, varargin);
   % load(opts.fulldataDir);%loading training set to valuate the sub-model
    %import the sub-model
    load(opts.fullmodelDir);
    net.layers{1,end}.type='softmax';
    trainmean=single(datamean);
        m=size(images.labels,2);
        pre=zeros(1,m);
        scores=[];
        res=[];
        for i=1:m
            im_=single(images.data(:,:,1,i));
            im_=im_-trainmean;
            res=vl_simplenn(net,im_);
            scores=squeeze(gather(res(end).x));
            [bestscore best]=max(scores);
            pre(1,i)=best;
        end
    pre=pre-1;
    wrongclass=find(pre~=images.labels);
   % save needretrain_horizontal wrongclass;
 end

