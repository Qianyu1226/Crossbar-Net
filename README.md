# Crossbar-Net
## Crossbar-Net: *Regions with Convolutional Neural Network Segmentation*

Created by Qian Yu, Yinhuan Shi, Jinquan Sun and Yang Gao at Nanjing University.


### Introduction
This work is designed for kidney tumor segmentation, but it can be easily modified to be used in other 2D medical segmentation applications.
The code runs on Matconvnet1.0-beta20. This is the CPU version and you can change it to the GPU version easily.

### Citing Crossbar-Net

If you find Crossbar-Net useful, please consider citing:

  @article{Qian2018crossbar,
  author= {Qian Yu, Yinhuan Shi, Jinquan Sun, Yang Gao,Jianbing Zhu and Yakang Dai},
  title  = {Crossbar-Net: A Novel Convolutional Neural Network for Kidney Tumor Segmentation in CT Images},
  journal={arXiv preprint arXiv:1804.10484v2},
  year= {2018}
}

### Sampling training patches with basic sampling strategy.
1. Place the folder "kidneytumor" in the matconvnet\examples\ folder.
   Place the folder "kidney-baseline-simplenn" in the matconvnet\data\ folder.
2. Four mat files should be created based on your training images and ground truth, which are listed in the matconvnet\examples\kidneytumor\basic_sampling.m.
3. Run basic_sampling.m. The data_horizontal.mat and data_vertical.mat are saved in kidney-baseline-simplenn\horizontal and kidney-baseline-simplenn\vertical, respectively.
### Training sub-models.
If you have prepared the the training patches according to the basic_sampling strategy, that is, the data_horizont.mat and
    the data_vertical.mat have been created, you can run the Patch_imdb.m to create the imdb data. Then place the imdb data in kidney-baseline-simplenn\horizontal and kidney-baseline-simplenn\vertical, respectively. Finally, runing the training_submodels.m.
### Testing sub-models.
Runing the test_experiment.m. This program can be runned directly without any data being prepared. Six sub-models (e.g., H1, H2, H3, V1, V2, V3) are given in the kidney-baseline-simplenn\horizontal and kidney-baseline-simplenn\vertical. In order to show the visualization clearly, we only list the results of H1 and V1, but you can test the remaining sub-models at any time in the similar manner with H1 and V1.
