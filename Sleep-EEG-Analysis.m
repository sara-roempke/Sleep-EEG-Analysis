%% Sleep EEG Analysis
% This script processes EEG sleep data from EDF and XML files, including
% filtering, denoising, and feature extraction.

clc;
close all;
clear;

%% Load EDF and XML files with error handling
edfFilename = 'R4.edf';
xmlFilename = 'R4.xml';

if ~isfile(edfFilename) || ~isfile(xmlFilename)
    error('Error: One or both input files are missing. Please check the file paths.');
end

[hdr, record] = edfread(edfFilename);
[events, stages, epochLength, annotation] = readXML(xmlFilename);

%% Extract EEG signal
index = find(strcmp(hdr.label, 'EEG'), 1); % Ensure only one match
if isempty(index)
    error('EEG channel not found in EDF file. Check the channel labels.');
end

Fs = hdr.samples(index); % Sampling rate
EEG_signal = record(index, :);

%% Split signal into epochs
epochSamples = Fs * epochLength;
num_epochs = floor(length(EEG_signal) / epochSamples);
signal = reshape(EEG_signal(1:num_epochs * epochSamples), epochSamples, num_epochs)';

%% Filter the EEG signal
signal_filt = bandpassFilter(signal, Fs, [0.3, 35]);
signal_LPfilt = lowpassFilter(signal_filt, Fs, 8);

%% Denoise signal using wavelet transform
signal_denoised = waveletDenoise(signal_filt, 'db2', 128);

%% Plot a sample epoch
plotEEGSignals(signal, signal_filt, signal_LPfilt, signal_denoised, Fs);

%% Extract features
[featureMatrix, sleepStageLabels] = extractFeatures(signal_denoised, stages, Fs);

%% Helper functions
function filteredSignal = bandpassFilter(signal, Fs, band)
    [b, a] = butter(2, band / (Fs / 2), 'bandpass');
    filteredSignal = filtfilt(b, a, signal);
end

function lowFilteredSignal = lowpassFilter(signal, Fs, cutoff)
    [b, a] = butter(2, cutoff / (Fs / 2), 'low');
    lowFilteredSignal = filtfilt(b, a, signal);
end

function denoisedSignal = waveletDenoise(signal, wavelet, scales)
    denoisedSignal = zeros(size(signal));
    for epoch = 1:size(signal, 1)
        [C, L] = wavedec(signal(epoch, :), max(scales), wavelet);
        noise_std = median(abs(C)) / 0.6745;
        threshold = noise_std * sqrt(2 * log(length(signal(epoch, :))));
        C_denoised = wthresh(C, 's', threshold);
        denoisedSignal(epoch, :) = waverec(C_denoised, L, wavelet);
    end
end

function plotEEGSignals(signal, filt, lpFilt, denoised, Fs)
    epochNumber = 100;
    t = (1:size(signal, 2)) / Fs;
    figure;
    subplot(3, 1, 1); plot(t, signal(epochNumber, :), 'k'); title('Original Signal');
    subplot(3, 1, 2); plot(t, filt(epochNumber, :), 'b'); title('Bandpass-Filtered Signal');
    subplot(3, 1, 3); plot(t, lpFilt(epochNumber, :), 'm'); title('Lowpass-Filtered Signal');
    figure;
    plot(t, denoised(epochNumber, :), 'r'); title('Denoised Signal');
end

function [features, labels] = extractFeatures(signal, stages, Fs)
    num_epochs = size(signal, 1);
    features = zeros(num_epochs, 6);
    labels = strings(num_epochs, 1);
    for i = 1:num_epochs
        epoch = signal(i, :);
        mav = mean(abs(epoch));
        variance = var(epoch);
        [pxx, f] = pwelch(epoch, [], [], [], Fs);
        centroid = sum(f .* pxx) / sum(pxx);
        [~, maxIdx] = max(pxx);
        peakFreq = f(maxIdx);
        features(i, :) = [mav, variance, centroid, peakFreq];
        labels(i) = convertStage(stages(i));
    end
end

function stageName = convertStage(stage)
    switch stage
        case 0, stageName = "REM";
        case 1, stageName = "N1";
        case 2, stageName = "N2";
        case 3, stageName = "N3";
        case 4, stageName = "Wake";
        otherwise, stageName = "Unknown";
    end
end
