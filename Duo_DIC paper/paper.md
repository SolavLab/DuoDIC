---
title: 'DuoDIC: A for Stereo 3D Digital Image Correlation MATLAB package'
tags:
  - MATLAB
  - digital image correlation
  - material testing
  - full-field strain
  - full-field deformations
  - Ncorr
  - Stereo camera calibration
authors:
  - name: Dana Solav^[corresponding author]
    orcid: 0000-0003-0872-7098
    affiliation: "1"
  - name: Asaf Silverstein
    affiliation: "1"

affiliations:
 - name: Faculty of Mechanical Engineering, Technion, Haifa, Israel
   index: 1


date: 13 December 2021
bibliography: paper.bib

---
# Summary

Three-dimensional Digital Image Correlation (3D-DIC) is a non-contact optical-numerical technique for evaluating the shape and full-field displacement, deformation, and strain, from stereo digital images of the surface of an object. 3D-DIC is useful for characterizing the mechanical behavior of material  structures, quantifying material parameters, and validating numerical simulations. DuoDIC is a freely available open source MATLAB toolbox for 2-camera stereo DIC, which can be used either as a standalone package or as functions in external scripts. DuoDIC takes in two series of digital images taken from two synchronized cameras. The first series contains a flat checkerboard calibration target and the second contains the speckled test object. The toolbox outputs and plots the 3D point cloud, meshed surface, displacements, deformations, strains, and rigid body motion. DuoDIC integrates the bundle adjustment stereo camera calibration algorithm with the 2D subset-based DIC software Ncorr, as well as advanced functions to compute and visualize various 3D measures of shape, displacement, deformation, and strain. The user interface allows users to perform 3D-DIC analyses without interacting with MATLAB syntax, while stand-alone functions can be integrated in custom scripts by more proficient MATLAB users. The package is composed of four main scripts: 1) stereo calibration; 2) 2D cross-correlation; 3) 3D reconstruction; and 4) post-processing. This paper describes the algorithms implemented in each DuoDIC and demonstrates its performance in four test cases: 1) rigid body motion; 2) uniaxial tension; 3) tube inflation; and 4) compression. The sample data is included with the package.


# Statement of need

Three-dimensional Digital Image Correlation (3D-DIC) is useful in numerous applications where the full-field displacements and strains are required, primarily for measuring the mechanical response of materials and structures, for characterizing the mechanical properties, and for quantifying material parameters. Commercial 3D-DIC software are typically expensive and consist of closed-source code, which may pose a barrier for researchers. A few open-source alternative exist [@Turner2015, @Atkinson2021, @Solav2018] BUT????. Our previous publication, MultiDIC [@Solav2018], offers a free open-source alternative to 3D-DIC, but it required the fabrication of a 3D calibration object, which is difficult to make accurate, and creates another barrier for implementation. To this end, this toolbox allows for 3D-DIC with a simple calibration procedure that requires only a flat checkerboard. In addition, we improved the post-processing step and plotting options. This package is simple to use and to modify to the researcher’s needs. Here, we present DuoDIC, an open-source MATLAB toolbox, which was designed to be easy to use by students, researchers, and engineers in both academia and industry. Its MATLAB implementation makes it easy to modify and interact with, even for users with minimal coding experience.

# Algorithms
 Figure \autoref{fig:workflow} outlines the workflow of the 3D-DIC procedure, which is organized in four main scripts. Each colored box describes one of the four main script, and the functionality and algorithms included in each step are described below.

![DuoDIC algorithm workflow. Each color represent one main script\label{fig:workflow}](fig_workflow.png)

## Step 1: Stereo camera calibration
In this step, the intrinsic and extrinsic parameters of both cameras are computed. The script receives simultaneous images of a checkerboard target from two cameras, and utilizes MATLAB's Stereo Camera Calibrator App, which automatically detects the checkerboard pattern on multiple image pairs from and calibrates the stereo camera pair. The stereo calibration computes the  intrinsic parameters: focal length, principal points, and distortion coefficients. The user can choose between [0,2,3] radial distortion coefficients, [0,2]] tangential distortion coefficients, and [0,1] skew parameter. The extrinsic parameters compose the position and orientation of the second camera with respect to the first, and the reprojection errors are calculated by implementing the algorithms by Zhang [@Zhang2000] and Heikkila and Silven [@Heikkila1997].

## Step 2: Ncorr cross Correlation
In this step, Ncorr [@Blaber2015] is used to detect corresponding image points on the set of images containing the speckled test object. All  images from both cameras are correlated with the reference image, as demonstrated in Figure \autoref{fig:corr}
Corresponding points in the region of interest (ROI) are detected on the speckle images using Ncorr [@Blaber2015].
The correlated points are imported using DuoDIC and the point cloud is meshed with triangular elements for the post-processing step.

![image point correspondence calculated using cross-correlation  with Ncorr.\label{fig:corr}](fig_correlation.png)


## Step 3: 3D reconstruction
The results from step 1 and step 2 are combined in this step to obtain the 3D position of each point using stereo triangulation. Matching points on each two stereo images (as computed in step 2) are first being undistorted using the intrinsic camera parameters of each camera, and then transformed into 3D world points using the stereo camera parameters (computed in step 1).

## Step 4: Displacement, strain, deformation, what parameters can be plotted
The 3D coordinates calculated in step 3 are used in this step to derive the full-field displacement, deformation, and strain maps. The displacements are calculated for each point (vertices of the triangular elements), and the deformations and strains are calculated for the triangular faces using the Cosserat point element method [@Solav2014, @Solav2016, @Solav2017, @Solav2017b]. For each triangular element, the vertices position vectors are used to calculate the deformation gradient tensor, from which the following deformation and strain parameters are computed: deformation gradient tensor ($F$), right Cauchy-Greed deformation tensor (C), left Cauchy-Greed deformation tensor (B), Green-Lagrangian strain tensor (E), Eulerian-Almansi strain tensor (e), area change (J), principal stretches ($\Lambda_{i}$), principal strains, principal directions, equivalent strains, and maximal shear strains.
Moreover, this scripts allows numerous plotting options, as detailed in the next section.

# Validation and demonstration
We performed fours sets of tests to validate and demonstrate the metrological capability of the toolbox.

Experimental setup
The stereo camera setup consisted of two BFS-U3-51S5M-C cameras (FLIR, USA), each with a 5.0 MP Sony IMX250 monochrome sensor and a Fujinon HF12.5SA-1 lens (Fujifilm Corporation, Japan). The cameras were synchronously hardware-triggered using a triggerbox (MatchID, Belgium)

1. Rigid body motion
2. Uniaxial tension
3. Inflation
4. Compression


# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Figure sizes can be customized by adding an optional second parameter:
![Caption for example figure.](figure.png){ width=20% }

# Acknowledgements
This project was supported by Dana Solav's Jacques Lewiner Carrer Advancement Chair.
We acknowledge contributions from xxx and support from yyy.

# References
