## Crossbar-Net: *Regions with Convolutional Neural Network Segmentation*

Created by Qian Yu, Yinhuan Shi, Jinquan Sun and Yang Gao at Nanjing University.


### Introduction
This work is designed for kidney tumor segmentation, but it can be easily modified to be used in other 2D medical segmentation applications.
The code runs on Matconvnet1.0-beta20.

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

### Training sub-models
    Runing the training_submodels.m.

### Testing
    Runing the test_experiment.m.