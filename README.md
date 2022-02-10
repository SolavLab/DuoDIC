# `DuoDIC`: a `MATLAB` Toolbox for 2-camera stereo 3D Digital Image Correlation (3D-DIC)  

- [Summary](#Summary)  
- [Installation](#Installation)  
- [Getting started](#Start)
- [Citing](#Cite)
- [Contributing](#Contributing)  
- [Application Highlights](#Applications)
- [Publications](#Publications)
- [License](#License)  

## Summary <a name="Summary"></a>
`DuoDIC` is an open-source MATLAB toolbox by [Dana Solav](https://www.solavlab.com/). Three-dimensional (stereo) Digital Image Correlation (3D-DIC) is an important technique for measuring the mechanical behavior of materials. `DuoDIC` was developed to allow simple calibration and data processing, and to be easily adaptable to different experimental requirements. `DuoDIC` integrates the 2D-DIC subset-based software [Ncorr](https://www.github.com/justinblaber/ncorr_2D_matlab) with MATLAB's camera calibration algorithms to reconstruct 3D surfaces from stereo image pairs. Moreover, it contains algorithms for computing and visualizing 3D displacement, deformation and strain measures. High-level scripts allow users to perform 3D-DIC analyses with minimal interaction with MATLAB syntax, while proficient MATLAB users can also use stand-alone functions and data-structures to write custom scripts for specific experimental requirements. Comprehensive documentation, [instruction manual](https://github.com/SolavLab/DuoDIC/blob/master/docs/pdf/DuoDIC_v_1_1_0_instruction_manual.pdf), and [sample data](https://github.com/SolavLab/DuoDIC/tree/master/sample_data) are included.  

## Installation <a name="Installation"></a>  
### System Requirements
MultiDIC was developed and tested on 64-bit Windows 10 and has not yet been tested on other platforms.        
#### MATLAB
MultiDIC was developed on MATLAB versions R2021a and R2021b, and has not yet been tested on prior versions.  

MATLAB toolbox dependencies:
* Image Processing Toolbox
* Computer Vision System Toolbox
* Statistics and Machine Learning Toolbox

### Installation Instructions
To install MultiDIC simply follow these two steps:
#### 1. Get a copy of MultiDIC
Use **one** of these two options:      
**a.** Download and unzip the latest [zip file](https://github.com/MultiDIC/MultiDIC/archive/master.zip).   
**b.** Clone MultiDIC using: `git clone https://github.com/MultiDIC/MultiDIC/.git`.

#### 2. Install (or add to path)    
In MATLAB, navigate to the unzipped MultiDIC folder, type `installMultiDIC` in the command window, and hit Enter.   

## Getting started <a name="Start"></a>
Check out the [instruction manual](https://github.com/SolavLab/DuoDIC/blob/master/docs/pdf/DuoDIC_v_1_1_0_instruction_manual.pdf). It should have all the information you need to get started.


## Citing <a name="Cite"></a>   
This is the official repository for the paper:

`coming soon`
Please cite this paper if you use the toolbox.


## Contributing <a name="Contributing"></a>   
If you wish to contribute code/algorithms to this project, or to propose a collaboration study, please send an email to danas@technion.ac.il .

## License <a name="License"></a>
