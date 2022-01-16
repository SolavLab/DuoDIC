---
title: 'DuoDIC: Stereo 3D Digital Image Correlation in MATLAB'
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

Three-dimensional Digital Image Correlation (3D-DIC) is a non-contact optical-numerical technique for evaluating the shape and full-field displacement, deformation, and strain, from stereo digital images of the surface of an object. 3D-DIC is useful for characterizing the mechanical behavior of material and structures, for quantifying material parameters, and validating numerical simulations. DuoDIC is a freely available open source MATLAB toolbox for 2-camera stereo 3D-DIC, which can be used either as a standalone package or as functions in external scripts. DuoDIC takes in two series of synchronized digital images taken from two cameras. The first series, containing a flat checkerboard target, is used to calibrate the camera pair, and the second series contains the speckled test object undergoing movement and deformation. The toolbox can be used to output and visualizes the dynamic 3D point cloud, meshed surface, rigid body motion, and full-field displacement, deformation, and strain measures. DuoDIC integrates the bundle adjustment stereo camera calibration algorithm with the 2D subset-based DIC software Ncorr, as well as advanced functions to compute and visualize various 3D measures of shape, displacement, deformation, and strain. The user interface allows novice users to perform 3D-DIC analyses without interacting with MATLAB syntax, while stand-alone functions can be integrated in custom scripts by more proficient MATLAB users. As such, DuoDIC is suitable for students, researchers, and professionals. The package is composed of four main scripts: 1) stereo calibration; 2) image cross-correlation; 3) 3D reconstruction; and 4) post-processing. This paper describes the algorithms implemented in each step and demonstrates its performance in four test cases, which are included as sample data: 1) rigid body motion; 2) uniaxial tension; 3) tube inflation; and 4) compression.


# Statement of need

3D-DIC is useful in numerous applications where the full-field displacements and strains are required, primarily for measuring the mechanical response of materials and structures and for characterizing the mechanical properties. 3D-DIC is preferable over strain gages because it is non-contact and provides much more information on the deformation. It has widespread applications from nano- to macro-scale mechanical testing. Commercial 3D-DIC software are typically expensive and closed-source, which may pose a barrier, especially for students and researchers. A few open-source alternative exist [@Turner2015, @Atkinson2021]. However, they include different algorithms... Our previous open-source toolbox, MultiDIC [@Solav2018], offers a free open-source alternative to 3D-DIC, but it required the fabrication of a 3D calibration object, which is relatively difficult to make accurate, thus preventing easy implementation. To this end, this toolbox offers a simpler calibration procedure that requires only a flat checkerboard. In addition, we improved the post-processing and plotting options. This package is simple to use and to modify to any experimental setup.

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
The 3D coordinates calculated in step 3 are used in this step to derive the full-field displacement, deformation, and strain maps. The displacements are calculated for each point (vertices of the triangular elements), and the deformations and strains are calculated for the triangular faces using the Cosserat point element method [@Solav2014, @Solav2016, @Solav2017, @Solav2017b]. For each triangular element, the vertices position vectors are used to calculate the deformation gradient tensor, from which the following deformation and strain parameters are computed: deformation gradient tensor ($\textbf{F}$), right Cauchy-Greed deformation tensor ($\textbf{C}$), left Cauchy-Greed deformation tensor ($\textbf{B}$), Green-Lagrangian strain tensor ($\textbf{E}$), Eulerian-Almansi strain tensor ($\textbf{e}$), area change ($J$), principal stretches ($\lambda_{i}$), principal strains ($E_{i}$), principal directions ($\textbf{v}_{i}$), equivalent strains ($E_{eq}$), and maximal shear strains ($E_{ms}$).
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
