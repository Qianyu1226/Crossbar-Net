function [net, info] = cnn_main(varargin)
%CNN_MNIST  Demonstrates MatConvNet on MNIST

run(fullfile(fileparts(mfilename('fullpath')),...
  '..', '..', 'matlab', 'vl_setupnn.m')) ;

opts.batchNormalization = false ;
opts.network = [] ;
opts.networkType = 'simplenn' ;
opts.epochsnum='V1';
opts.HorV='V';
[opts, varargin] = vl_argparse(opts, varargin) ;
sfx = opts.networkType ;
if opts.batchNormalization, sfx = [sfx '-bnorm'] ; end
opts.expDir = fullfile(vl_rootnn, 'data', ['kidney-baseline-' sfx],'vertical') ;
opts.dataDir = fullfile(vl_rootnn, 'data', ['kidney-baseline-' sfx],'vertical') ;
[opts, varargin] = vl_argparse(opts, varargin) ;
%opts.imdbPath = fullfile(opts.expDir,'imdb.mat');
opts.imdbPath =opts.dataDir;
opts.train = struct() ;
[opts, varargin] = vl_argparse(opts, varargin) ;
opts.expDir
opts.imdbPath
if ~isfield(opts.train, 'gpus'), 
    opts.train.gpus = []; %if run on gpu, opts.train.gpus = [1].
end;

% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------

if isempty(opts.network)
    if strcmp(opts.HorV,'H');
        net = cnn_init_horizontal('batchNormalization', opts.batchNormalization, ...
        'networkType', opts.networkType,'epochsnum',opts.epochsnum) ;
    else
        net = cnn_init_vertical('batchNormalization', opts.batchNormalization, ...
        'networkType', opts.networkType,'epochsnum',opts.epochsnum) ;
    end
else
  net = opts.network ;
  opts.network = [] ;
end

% if exist(opts.imdbPath, 'file')
%   imdb = load(opts.imdbPath) ;
% else
%   sprintf('the imdb data is unavailable!');
% end
imdb = load(strcat(opts.imdbPath,'imdb.mat')) ;
net.meta.classes.name = arrayfun(@(x)sprintf('%d',x),1:2,'UniformOutput',false) ;

% --------------------------------------------------------------------
%                                                                Train
% --------------------------------------------------------------------

switch opts.networkType
  case 'simplenn', trainfn = @cnn_train ;
  case 'dagnn', trainfn = @cnn_train_dag ;
end

[net, info] = trainfn(net,imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 3)) ;

% --------------------------------------------------------------------
function fn = getBatch(opts)
% --------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

% --------------------------------------------------------------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
% --------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

% --------------------------------------------------------------------
function inputs = getDagNNBatch(opts, imdb, batch)
% --------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if opts.numGpus > 0
  images = gpuArray(images) ;
end
inputs = {'input', images, 'label', labels} ;

% --------------------------------------------------------------------
