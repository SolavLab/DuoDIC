# `DuoDIC`: a `MATLAB` Toolbox for stereo 3D Digital Image Correlation (3D-DIC)  

Cite `DuoDIC`: [![DOI](https://joss.theoj.org/papers/10.21105/joss.04279/status.svg)](https://doi.org/10.21105/joss.04279)

- [Summary](#summary)  
- [Installation](#installation)  
- [Getting started](#getting-started)
- [Citing](#citing)
- [Contributing](#contributing)  
- [License](#license)  
- [Application Highlights](#application-highlights)
- [Publications](#publications)


## Summary
`DuoDIC` is an open-source MATLAB toolbox by [Dana Solav's research group at Technion](https://www.solavlab.com/) for three-dimensional (stereo) Digital Image Correlation (3D-DIC) using two cameras. For multi-view (3 cameras or more), please visit our [MultiDIC toolbox](https://github.com/MultiDIC/MultiDIC). 3D-DIC is an important technique for measuring the mechanical behavior of materials. `DuoDIC` was developed to allow simple calibration and data processing, and to be easily adaptable to different experimental requirements. `DuoDIC` integrates the 2D-DIC subset-based software [Ncorr](https://www.github.com/justinblaber/ncorr_2D_matlab) with MATLAB's camera calibration algorithms to reconstruct 3D surfaces from stereo image pairs. Moreover, it contains algorithms for computing and visualizing 3D displacement, deformation and strain measures. High-level scripts allow users to perform 3D-DIC analyses with minimal interaction with MATLAB syntax, while proficient MATLAB users can also use stand-alone functions and data-structures to write custom scripts for specific experimental requirements. Comprehensive documentation, [instruction manual](https://github.com/SolavLab/DuoDIC/blob/master/docs/instructions/DuoDIC_v_1_1_0_instruction_manual.pdf), and [sample data](https://github.com/SolavLab/DuoDIC/tree/master/sample_data) are included.

## Installation  
### System Requirements
`DuoDIC` was developed and tested on 64-bit Windows 10 and has not yet been tested on other platforms.        
#### MATLAB
`DuoDIC` was developed on MATLAB versions R2021a and R2021b, and has not yet been tested on prior versions.  

MATLAB toolbox dependencies:
* Image Processing Toolbox
* Computer Vision System Toolbox
* Statistics and Machine Learning Toolbox

### Installation Instructions
To install `DuoDIC` simply follow these two steps:
#### 1. Get a copy of `DuoDIC`
Use **one** of these two options:  
**a.** Clone `DuoDIC` using: `git clone https://github.com/SolavLab/DuoDIC.git`.    
**b.** Download and unzip the latest [zip file](https://github.com/SolavLab/DuoDIC/archive/refs/heads/main.zip).   

#### 2. Install
In MATLAB, navigate to the (unzipped) `DuoDIC` folder, type `install_DuoDIC` in the command window, and hit Enter.

## Getting started
Check out the [instruction manual](docs/instructions/DuoDIC_instruction_manual_1_1_0.pdf). It should have all the information you need to get started.
It is important to note that successful DIC analysis requires high quality images, which require some expertise in constructing a good stereo-DIC setup. To learn how to do that, I highly recommend checking out the [iDICs Good Practices Guide](https://idics.org/guide/)!

## Citing  
This is the official repository for the paper:
[`DuoDIC`: 3D Digital Image Correlation in `MATLAB`'](https://joss.theoj.org/papers/10.21105/joss.04279)   
DOI: [![DOI](https://joss.theoj.org/papers/10.21105/joss.04279/status.svg)](https://doi.org/10.21105/joss.04279)

Please cite this paper if you use the toolbox.

## Contributing
If you wish to contribute code/algorithms to this project, or to propose a collaboration study, please send an email to danas@technion.ac.il .

## License <a name="License"></a>
`DuoDIC` is provided under the [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0). The [license file](https://github.com/SolavLab/DuoDIC/blob/main/LICENSE.txt) is found on the GitHub repository.

## Application Highlights
### These are some examples of figures obtained directly using `DuoDIC`:
#### Diplacement and principal strain fields of a dogbone sample under uniaxial tension
<img src="docs/img/disp_img.gif">     
<img src="docs/img/strains.gif">   

## Publications
### DuoDIC has been used in the following publications:
1. Molkens, Tom, et al. "Masonry design for extended life-time usage by implementing joint behaviour." Life-cycle of structures and infrastructure systems. [CRC Press, 2023. 1945-1952.](https://www.taylorfrancis.com/chapters/oa-edit/10.1201/9781003323020-238/masonry-design-extended-life-time-usage-implementing-joint-behaviour-molkens-smits-van-hout-meuleman)
1. Kumar, Rajesh, and Iniyan Thiruselvam. "Mechanics of Novel Double-Rounded-V Hierarchical Auxetic Structure: Finite Element Analysis and Experiments Using Three-Dimensional Digital Image Correlation." Society for Experimental Mechanics Annual Conference and Exposition. Cham: Springer Nature Switzerland, 2023. [doi.org/10.1007/978-3-031-50474-7_5](https://doi.org/10.1007/978-3-031-50474-7_5)
1. Naderi, Ali, et al. "Tensile Properties of Unidirectional Polymer Composites Reinforced by Aligned Carbon Nanotube Yarns." (2023). [DOI: 10.12783/asc38/36612
](https://www.researchgate.net/profile/Yeqing-Wang-3/publication/374119489_Tensile_Properties_of_Unidirectional_Polymer_Composites_Reinforced_by_Aligned_Carbon_Nanotube_Yarns/links/650eebcdc05e6d1b1c2acfd3/Tensile-Properties-of-Unidirectional-Polymer-Composites-Reinforced-by-Aligned-Carbon-Nanotube-Yarns.pdf)
1. Li, Xingyao, Ying Zhou, and Peiyan Mao. "System for Detecting Warpage Deformation in Printed Circuit Boards Based on Digital Image Correlation." 2024 4th International Conference on Electrical Engineering and Control Science (IC2ECS). IEEE, 2024. [doi.org/10.1109/IC2ECS64405.2024.10928691](https://doi.org/10.1109/IC2ECS64405.2024.10928691)
1. Rosalia, Luca, et al. "Programmable 3D cell alignment of bioprinted tissue via soft robotic dynamic stimulation." bioRxiv (2024): 2024-11. [doi.org/10.1101/2024.11.03.621771](https://doi.org/10.1101/2024.11.03.621771)
1. Cheng, Wei-Han, and Hsin-Haou Huang. "Image-Based Hidden Damage Detection Method: Combining Stereo Digital Image Correlation and Finite Element Model Updating." Sensors (Basel, Switzerland) 24.15 (2024): 4844. [doi.org/10.3390/s24154844](https://doi.org/10.3390/s24154844)
1. Bengtsson, Rhodel, et al. "Evaluating the viscoelastic shear properties of clear wood via off-axis compression testing and digital-image correlation." Mechanics of Time-Dependent Materials 28.4 (2024): 2069-2083. [doi.org/10.1007/s11043-023-09604-0](https://doi.org/10.1007/s11043-023-09604-0)
1. Apostolakis, Georgios, Kevin R. Mackie, and Mostafa Iraniparast. "UHPC girder multi-modal deformation measurements: Photogrammetry, physical sensing, and FEA." Structures. Vol. 70. Elsevier, 2024. [doi.org/10.1016/j.istruc.2024.107790](https://doi.org/10.1016/j.istruc.2024.107790)
1. Askar, Caroline Barbar, et al. "Human Activity Recording Based on Skin-Strain-Actuated Microfluidic Pumping in Asymmetrically Designed Micro-Channels." Sensors 24.13 (2024): 4207. [doi.org/10.3390/s24134207](https://doi.org/10.3390/s24134207)
1. Rupani, Mia, Luke D. Cleland, and Hannes P. Saal. "Local postural changes elicit extensive and diverse skin stretch around joints, on the trunk and the face." Journal of the Royal Society Interface 22.223 (2025): 20240794. [doi.org/10.1098/rsif.2024.0794](https://doi.org/10.1098/rsif.2024.0794)
1. Ruan, Xiongfeng, et al. "Generalised notch stress method to evaluate the fatigue behaviour of rough and smooth wire arc additively manufactured components." International Journal of Fatigue (2025): 109045. [doi.org/10.1016/j.ijfatigue.2025.109045](https://doi.org/10.1016/j.ijfatigue.2025.109045)
1. Chen, Siyuan, et al. "Preform variability propagation in non-crimp fabric (NCF) forming." Composites Part B: Engineering 299 (2025): 112418. [doi.org/10.1016/j.compositesb.2025.112418](https://doi.org/10.1016/j.compositesb.2025.112418)
1. Li, Yanbing, Yande Liu, and Rong Wu. "Employing an optical configuration for full-surface 360° measurement in multi-view digital image correlation." Optics and Lasers in Engineering 191 (2025): 108986. [doi.org/10.1016/j.optlaseng.2025.108986](https://doi.org/10.1016/j.optlaseng.2025.108986)
1. Gasvoda, Hudson, et al. "Computer‐Aided Design of Integrated Digital Strain Sensors for Hardware‐Based Recognition and Quantification of Human Movements." Advanced Sensor Research (2025): 2400146. [/doi.org/10.1002/adsr.202400146](https://doi.org/10.1002/adsr.202400146)
1. Thomas, Patricia K., et al. "Material characterization of ovine lung parenchyma at pressures representing the breathing cycle." Journal of Biomechanical Engineering (2025): 1-29.[doi.org/10.1115/1.4068872](https://doi.org/10.1115/1.4068872)
1. Wang, Yating, et al. "Experimental study of internal deformation in 3D solids with embedded parallel cracks during the fracture process using multi-material 3D printing and stereo digital image correlation." Theoretical and Applied Fracture Mechanics 137 (2025): 104884.[doi.org/10.1016/j.tafmec.2025.104884](https://doi.org/10.1016/j.tafmec.2025.104884)
1. Gautam, Kushagra, Dana Solav, Shany Barath, and Guy Austern. "Using Digital Image Correlation to Analyze Deformation in Wood-based Liquid Deposition Modelling". [Proceedings of the 30th International Conference of the Association for Computer-Aided Architectural Design Research in Asia (CAADRIA) 2025, Volume 2, 49-58.](https://www.researchgate.net/profile/Kushagra-Gautam-3/publication/390972230_Using_Digital_Image_Correlation_to_Analyze_Deformation_in_Wood-based_Liquid_Deposition_Modelling/links/68063853df0e3f544f437df3/Using-Digital-Image-Correlation-to-Analyze-Deformation-in-Wood-based-Liquid-Deposition-Modelling.pdf)
