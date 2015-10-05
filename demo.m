% Stimulus metrics are in mm
stimulusSizePixels = 240;
stimulusSizeMetric = 75;
viewDistance = 50;
stimulusOrientation = 45;
visualDegrees = 0.0678;

% 1. Compute stimulus size in degrees
stimulusSizeDegrees = metric2vd(stimulusSizeMetric,viewDistance);

% 2. Calculate coordinate system in visual degrees
[X,Y] = scale2degree(stimulusSizeDegrees, stimulusSizePixels);

% 3. Create the grating
grating = CreateGrating(X,Y, stimulusOrientation, visualDegrees);

% 4. Show it
imshow(grating,[])