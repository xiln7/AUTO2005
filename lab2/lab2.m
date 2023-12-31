% Fast Fourier Transform
clc; clear; close all;

% Define parameters
totalTime = 0.064;
samplingFrequencies = [1000 300 200];
samplingPeriods = 1 ./ samplingFrequencies;
numSamples = round(totalTime .* samplingFrequencies);

% Initialize arrays
signalTimeDomain = zeros(length(samplingFrequencies), max(numSamples));
signalFrequencyDomain = zeros(length(samplingFrequencies), max(numSamples));

% Compute FFT for each sampling frequency
for freqIndex = 1:length(numSamples)
    for sampleIndex = 1:numSamples(freqIndex)
        signalTimeDomain(freqIndex, sampleIndex) = myfun1(sampleIndex * samplingPeriods(freqIndex));
    end
    signalFrequencyDomain(freqIndex, 1:numSamples(freqIndex)) = fft(signalTimeDomain(freqIndex, 1:numSamples(freqIndex)));
end

% Plot time and frequency domain signals for each sampling frequency
figure
for freqIndex = 1:length(numSamples)
    subplot(3, 2, 2*freqIndex-1)
    stem((1:numSamples(freqIndex)) * samplingPeriods(freqIndex), signalTimeDomain(freqIndex, 1:numSamples(freqIndex)))
    title(['amplitude-time fs = ', num2str(samplingFrequencies(freqIndex)), 'Hz'])
    
    subplot(3, 2, 2*freqIndex)
    plot((1:numSamples(freqIndex)) * samplingPeriods(freqIndex), signalFrequencyDomain(freqIndex, 1:numSamples(freqIndex)))
    title(['amplitude-frequency fs = ', num2str(samplingFrequencies(freqIndex)), 'Hz'])
end

% Define parameters for second part
numSamples2 = [32 16];
angularFrequency = 2*pi ./ numSamples2;

% Initialize arrays
signalTimeDomain2 = zeros(length(numSamples2), max(numSamples2));
signalFrequencyDomain2 = zeros(length(numSamples2), max(numSamples2));
signalTimeDomain3 = zeros(length(numSamples2), max(numSamples2));

% Compute FFT and inverse FFT for each number of samples
for sampleIndex = 1:length(numSamples2)
    for n = 1:numSamples2(sampleIndex)
        signalTimeDomain2(sampleIndex, n) = myfun2(n-1);
    end
    signalFrequencyDomain2(sampleIndex, 1:numSamples2(sampleIndex)) = fft(signalTimeDomain2(sampleIndex, 1:numSamples2(sampleIndex)));
    signalTimeDomain3(sampleIndex, 1:numSamples2(sampleIndex)) = ifft(signalFrequencyDomain2(sampleIndex, 1:numSamples2(sampleIndex)));
end

% Plot time and frequency domain signals for each number of samples
figure
for sampleIndex = 1:length(numSamples2)
    subplot(2, 3, 3*sampleIndex-2)
    stem((1:numSamples2(sampleIndex)), signalTimeDomain2(sampleIndex, 1:numSamples2(sampleIndex))) 
    title(['amplitude-sequency N = ', num2str(numSamples2(sampleIndex))])
    
    subplot(2, 3, 3*sampleIndex-1)
    plot((1:numSamples2(sampleIndex)) * angularFrequency(sampleIndex), signalFrequencyDomain2(sampleIndex, 1:numSamples2(sampleIndex)))
    title(['amplitude-frequency N = ', num2str(numSamples2(sampleIndex))])
    
    subplot(2, 3, 3*sampleIndex)
    plot((1:numSamples2(sampleIndex)), signalTimeDomain3(sampleIndex, 1:numSamples2(sampleIndex)))
    title(['amplitude-frequency N = ', num2str(numSamples2(sampleIndex))])
end

% Define function for first part
function y = myfun1(x)
    amplitude = 444.128;
    decayRate = 50*sqrt(2)*pi;
    frequency = 50*sqrt(2)*pi;
    y = amplitude * exp(-decayRate * x) * sin(frequency * x) * (x > 0);
end

% Define function for second part
function y = myfun2(n)
    if n >= 0 && n <= 13
        y = n + 1;
    elseif n >= 14 && n <= 26
        y = 27 - n;
    else
        y = 0;
    end
end