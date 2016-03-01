%% Demo script to illustrate the principles of the fourier transform

% 1. Set artificial signal properties
signalAmplitude = 6;      % Signal amplitude
signalFrequency = 5;      % Signal frequency
signalPhaseOffset = pi/2;
samplingFrequency = 100;    % Sampling frequency
sampleInterval = 1/samplingFrequency;
totalTime = 1; % Total time for signal generation in seconds
nSamples = samplingFrequency*totalTime;

% 2. Generate the signal
time = 0:sampleInterval:(nSamples-1)*sampleInterval;
signal = signalAmplitude.*sin(2*pi*signalFrequency.*time + signalPhaseOffset);
%signal = signal + (signalAmplitude.*sin(2*pi*2*signalFrequency.*time + signalPhaseOffset));

% 3. Apply the transform and extract magnitude and phase
% If you plot the amplitude spectrum you will see that the obtained
% coefficients do not correspond to the values we used to generate the
% signal. This is a consequence of the way the fourier transform is defined
% in Matlab. To obtain the true coefficients we need to perform some
% scaling, as has been done on the magnitude vector. Most of the time, only
% the general shape of the amplitude spectrum is of importance, and not the
% actual values that can be obtained through different scaling techniques
dft = fft(signal);
magnitude = abs(dft)./nSamples;
magnitude(2:(end)) = magnitude(2:(end)).*2;
amplitudeSpectrum = abs(dft);
powerSpectrum = abs(dft).^2;
powerSpectrumDb = 20*log10(powerSpectrum);
phase = angle(dft);

% 1D signals are typically recorded in the time domain using seconds as
% dimensional unit. The corresponding unit in the frequency domain is Hz.
% The following code constructs the correct unit axis
frequencyAxis = samplingFrequency.*(0:(nSamples-1))./nSamples;
% 4. Plot the results
% You can plot the 
figure,
subplot(3,2,1),plot(time,signal), title('Time domain signal')
subplot(3,2,3),plot(frequencyAxis,magnitude,'o-'), title('True magnitude spectrum')
subplot(3,2,5),plot(frequencyAxis,phase,'o-'), title('Phase spectrum')

subplot(3,2,2),plot(frequencyAxis, amplitudeSpectrum), title('Amplitude spectrum')
subplot(3,2,4),plot(frequencyAxis, powerSpectrum), title('Power spectrum')
subplot(3,2,6),plot(frequencyAxis, powerSpectrumDb), title('Power spectrum (dB)')

%% Intuitive explanation of why the fourier transform is mirrored
% Generate a sine wave with different sampling frequencies
samplingFrequency = 100;    
sampleInterval = 1/samplingFrequency;
nSamples = 100;
time1 = 0:sampleInterval:(nSamples-1)*sampleInterval;

% Now see what happens if we increase the sampling frequency
samplingFrequency = 1000;
sampleInterval = 1/samplingFrequency;
nSamples = 1000;
time2 = 0:sampleInterval:(nSamples-1)*sampleInterval;

signal1 = sin(2*pi*10.*time1);
signal2 = sin(2*pi*10.*time2);
signal3 = sin(2*pi*90.*time1);
signal4 = sin(2*pi*90.*time2);

clf,
subplot(2,1,1), hold on
plot(time1, signal1,'o','color','r')
plot(time2, signal2), set(gca, 'XLim',[0 0.25])
subplot(2,1,2), hold on
plot(time1, signal3,'o','color','r')
plot(time2, signal4), set(gca,'XLim',[0 0.25])
%% 