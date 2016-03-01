function [ imR, imI, im ] = PhaseScramble( im, distributionMethod, scrambleMethod, noiseSigma)
%PhaseScramble
% Performs phase scrambling on a grayscale input image which has power of
% two dimensions. Care is taken to preserve the symmetry of the phase spectrum.
%
% distribution method specifier:
% 'original'   : performs straightforward phase scrambling on the input image
%                without trying to preserve the pixel distribution
% 'replacehist': performs phase scrambling, but replaces the pixel
%                distribution of the transformed image with the original pixel
%                distribution (this affects the power spectrum)
% 'normhist'  : performs phase scrambling by generating a normal pixel
%                distribution and replacing the original distribution with
%                that distribution. For the output image, data is
%                transformed to the range [0 255]
%
% scramble method specifier:
% 'shuffle': shuffle the original phase values
% 'noise'  : replaces phase spectrum with phase spectrum of white noise
% 'offset' : add a random offset to the original phase values

%noiseSigma = 0.5;


xDim = size(im,1)/2;
yDim = size(im,2)/2;

% Check if we want to work on the normalized image
if strcmp(distributionMethod,'normhist')
    normDist = randn(size(im));
    normDist = sort(normDist(:));
    [~, imOrder] = sort(im(:));
    im(imOrder) = normDist;
end

% Perform phase scrambling
switch scrambleMethod
    case 'shuffle'
        fAngle = angle(fftshift(fft2(im)));
        fAngle = reshape(Shuffle(fAngle(:)), size(fAngle));
        fAngle((xDim+1):(2*xDim),(yDim+1):-1:2) =     -fAngle((xDim+1):-1:2,(yDim+1):(2*yDim));
        fAngle((xDim+1):(2*xDim),(yDim+1):(2*yDim)) = -fAngle((xDim+1):-1:2,(yDim+1):-1:2);
    case 'noise'
        fAngle = angle(fftshift(fft2(randn(size(im)))));
        
    case 'offset'
        fAngle = angle(fftshift(fft2(im)));
        fAngle = fAngle + noiseSigma*randn(size(fAngle));
        fAngle((xDim+1):(2*xDim),(yDim+1):-1:2) =     -fAngle((xDim+1):-1:2,(yDim+1):(2*yDim));
        fAngle((xDim+1):(2*xDim),(yDim+1):(2*yDim)) = -fAngle((xDim+1):-1:2,(yDim+1):-1:2);
end

% Reverse the transformation
fSpectrum = abs(fftshift(fft2(im)));
imR = real(ifft2(ifftshift(fSpectrum .* exp(1i*fAngle))));
imI = imag(ifft2(ifftshift(fSpectrum .* exp(1i*fAngle))));


% And adjust the distributions if necessary
if strcmp(distributionMethod, 'replacehist')
    [originalSorted] = sort(im(:));
    [~, newOrder] = sort(imR(:));
    imR(newOrder) = originalSorted;

elseif strcmp(distributionMethod, 'normhist')
    imR = 255.*(imR - min(imR(:)))./(max(imR(:)) - min(imR(:)));
    im = 255.*(im - min(im(:)))./( max(im(:)) - min(im(:)));
end
        
end

