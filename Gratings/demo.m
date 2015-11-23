% 0. Stimulus parameters
stimulusSizePixels = 240; % Size in pixels
stimulusSizeMetric = 75;  % Size in mm
viewDistance = 100;       % Viewing distance in mm
stimulusOrientation = 0;  % Orientation in degrees
cyclesPerDegree = 1.2;

% 1. Compute stimulus size in degrees
stimulusSizeDegrees = metric2vd(stimulusSizeMetric,viewDistance);

% 2. Calculate coordinate system in visual degrees
[X,Y] = scale2degree(stimulusSizeDegrees, stimulusSizePixels);

% 3. Create the grating
grating = CreateGrating(X,Y, stimulusOrientation, cyclesPerDegree);

% 4. Show it
imshow(grating,[])

% 5. Pixel intensities are in the range [-1, 1], the following line scales
% the image to [0, 1] range
gratingScaled = (grating+1)./2;
