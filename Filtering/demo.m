% Demo script to illustrate how spatial frequency filtering should be done

% 1. Create grating pattern
stimulusSizePixels = 240; % Size in pixels
stimulusSizeMetric = 75;  % Size in mm
viewDistance = 100;       % Viewing distance in mm
stimulusOrientation = 0;  % Orientation in degrees
cyclesPerDegree = 1.2;
stimulusSizeDegrees = metric2vd(stimulusSizeMetric,viewDistance);
[X,Y] = scale2degree(stimulusSizeDegrees, stimulusSizePixels);

% Create two gratings with different parameters
or1 = 45;
or2 = 121;
cpd1 = 0.1;
cpd2 = 1.5;
grating1 = CreateGrating(X,Y, or1, cpd1);
grating2 = CreateGrating(X,Y, or2, cpd2);
grating3 = grating1 + grating2;

% Show grating
imshow(grating3,[])

% Apply FFT and show result
ft = fftshift(fft2(grating3));
imshow(real(ft),[])

% Explain the coordinate system of the FFT image

% Show how we can filter the image

% Go back to the original image