# Sleep-EEG-Analysis

A MATLAB-based pipeline for processing EEG sleep data. The script loads EEG signals, applies preprocessing (filtering & denoising), extracts features, and visualizes results.

## Features
- Loads EEG data from `.edf` and `.xml` files
- Preprocessing: epoch segmentation, bandpass filtering, wavelet denoising
- Feature extraction: spectral flux, flatness, centroid, peak frequency, MAV, variance
- Visualization of raw, filtered, and denoised signals

## Requirements
- **MATLAB** (with Signal Processing & Wavelet Toolbox)
- EEG data files (`.edf` and `.xml`)

## Usage
1. Clone the repository:
   ```sh
   git clone https://github.com/sara-roempke/Sleep-EEG-Analysis.git
   cd Sleep-EEG-Analysis
   ```
2. Place EEG files in the project folder.
3. Run in MATLAB:
   ```matlab
   sleep_eeg_analysis
   ```

## Author
Developed by **Sara Roempke**. Contributions are welcome!


