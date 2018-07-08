%% The first round: traing H1 and V1, finding the disclassifed patches and
%%then resample with the covering re-sampling strategy.
clear all;
run(fullfile(fileparts(mfilename('fullpath')),...
  '..', '..', 'matlab', 'vl_setupnn.m')) ;
data_horizontal_Dir='data/kidney-baseline-simplenn/horizontal/';
data_vertical_Dir='data/kidney-baseline-simplenn/vertical/';
fulldata_horizontal_Dir=fullfile(vl_rootnn,data_horizontal_Dir);
fulldata_vertical_Dir=fullfile(vl_rootnn,data_vertical_Dir);
load('kidney_data\train_matrix.mat');%train images
load('kidney_data\train_gr.mat');%train ground truth
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Training sub-models in the first round.
 
[net_H1, info_bn] = cnn_main(...
  'expDir',fulldata_horizontal_Dir ,'dataDir',fulldata_horizontal_Dir, ...
  'batchNormalization', false,'epochsnum','H1','HorV','H');% sub-model: H1.

[net_V1, info_fc] = cnn_main(...
  'expDir', fulldata_vertical_Dir,'dataDir',fulldata_vertical_Dir, ...
  'batchNormalization', false,'epochsnum','V1','HorV','V');% sub-model: V1
% If you donnot want to train the next round, the program can stop here.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%valuating H1 and find the disclassified pixels
modelDir=strcat(data_horizontal_Dir,'net-epoch-20.mat');
dataDir=strcat(fulldata_horizontal_Dir,'data_horizontal.mat');
load(dataDir);
load('kidney_data\train_mean_horizontal.mat');
[NeedResample_H1] = sub_model_valuate(images,dataMean,'modelDir',modelDir);
%resampling the disclassified pixels and get the vertical patches which
%will be used to fine-tune V1 sub-model together with some baisc sampling vertical patches.
[resample_images, retrain_patch_location ] = Cover_resampling_HtoV( NeedResample_H1,images.location, train_gr, train_matrix )
save -v7.3 resample_patches_H1V1 resample_images;
save -v.3 retrain_location_H1V1 retrain_patch_location;
clear images resample_images retrain_patch_location;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% %valuating V1 and find the disclassified pixels
modelDir=strcat(data_vertical_Dir,'net-epoch-20.mat');
dataDir=strcat(fulldata_vertical_Dir,'data_vertical.mat');
load(dataDir);
load('kidney_data\train_mean_vertical.mat');
[NeedResample_V1] = sub_model_valuate(images,dataMean,'modelDir',modelDir);
%resampling the disclassified pixels and get the vertical patches which
%will be used to fine-tune V1 sub-model together with some baisc sampling vertical patches.
[resample_images, retrain_patch_location ] = Cover_resampling_HtoV( NeedResample_V1,images.location, train_gr, train_matrix )
save -v7.3 resample_patches_V1H1 resample_images;
save -v.3 retrain_location_V1H1 retrain_patch_location;
clear images resample_images retrain_patch_location;
%%%%% Notification%%%%%%%%%%%
% Then, combinging the resampled patches together with some basic sampling patche 
%   to start with the next round.
 
