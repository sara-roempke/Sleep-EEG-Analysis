# Sleep-EEG-Analysis
This repository contains a MATLAB-based pipeline for processing, filtering, and analyzing EEG sleep data. The script loads EEG signals, applies preprocessing techniques (such as filtering and wavelet denoising), extracts relevant features, and prepares the data for further analysis.

Features

EDF and XML file loading: Reads EEG sleep data from .edf and .xml files.

Preprocessing:

Signal segmentation into epochs

Bandpass filtering (0.5 - 4 Hz for EEG, 35 Hz low-pass for theta waves)

Wavelet-based denoising

Feature Extraction:

Spectral flux

Spectral flatness

Spectral centroid & peak frequency

Mean absolute value (MAV)

Variance

Visualization:

Raw EEG signal plots

Filtered and denoised signals comparison

Requirements

MATLAB (with Signal Processing Toolbox & Wavelet Toolbox)

EEG data files (.edf and .xml)

Installation & Usage

Clone the repository:

git clone https://github.com/sara-roempke/Sleep-EEG-Analysis.git
cd Sleep-EEG-Analysis

Place your EEG files (.edf and .xml) in the project directory.

Open MATLAB and run:

sleep_eeg_analysis

Example Plots

The script generates visualizations such as:

Raw EEG signals

Bandpass-filtered signals

Denoised signals after wavelet decomposition

Future Improvements

Machine learning classification for sleep stage detection

Support for additional EEG data formats

Integration with Python-based EEG analysis libraries
