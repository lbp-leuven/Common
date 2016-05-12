classdef V1Model < handle
    properties
        filterModels = {};
        filterParameters = [];
        filterResponses = [];
        nFilters = 0;
        
        windowSize = 3;
    end
    
    methods
        function obj = V1Model()
        end
        
        function Reset(obj)
            obj.filterModels = {};
            obj.filterParameters = [];
            obj.filterResponses = [];
            obj.nFilters = 0;
            obj.windowSize = 3;
        end
        
        % Add a filter to the model with following parameters:
        % size: single number, size in pixels of the filter
        % or  : filter orientation in degrees
        % sf  : Spatial frequency in cycles per pixel
        % sigma: two numbers, representing x and y variance of gaussian
        % phase: phase offset of the filter
        function AddFilter(obj,size, or, sf,sigma, phase)
            [X,Y] = meshgrid( (-size/2):1:(size/2-1), (-size/2):1:(size/2 - 1));
            
            xTheta = X.*cosd(or) + Y.*sind(or);
            yTheta = -Y.*sind(or) + X.*cosd(or);
            
            envelope = (1./sigma(1)*sigma(2)*sqrt(2*pi)).*exp(-0.5.*( (X./sigma(1)).^2 + (Y./sigma(2)).^2));
            carrier  = sin(2*pi*sf.*xTheta + phase);
            
            filter = envelope.*carrier;
            filter = filter-mean(filter(:));
            filter = filter./norm(filter(:));
            
            obj.nFilters = obj.nFilters + 1;
            obj.filterModels{obj.nFilters} = filter;
            obj.filterParameters(obj.nFilters,:) = [size or sf sigma phase];
        end
        
        % Processes inputImage,
        % A step vector can be used to specify which pre- and
        % postprocessing steps need to happen
        function filterOutput = ProcessImage(obj,inputImage, steps)
            % Make sure the image is in the correct format
            if strcmp(class(inputImage),'double') == 0
                inputImage = double(inputImage);
            end
            
            if length(size(inputImage)) == 3
                inputImage = rgb2gray(inputImage);
            end
            
            if nargin == 2
                steps = [1 1 1];
            end
            
            if steps(1) == 1
                normalizedImage = obj.DoImageNormalization(inputImage);
            end
            
            if steps(2) == 1
                normalizedImage = obj.DoInputNormalization(normalizedImage);
            end
            
            obj.FilterImage(normalizedImage);
            
            if steps(3) == 1
                obj.DoOutputNormalization();
            end
            
            filterOutput = obj.filterResponses;
        end
        
        % Make sure the image has zero mean and a standard deviation of one
        function outputImage = DoImageNormalization(obj, inputImage)
            outputImage = (inputImage-mean(inputImage(:)))./std(inputImage(:));
        end
        
        % Performs local input divisive normalization
        function outputImage = DoInputNormalization(obj,inputImage)
            windowedMean = conv2(inputImage,ones(obj.windowSize,obj.windowSize).*(1/(obj.windowSize^2)),'same');
            windowedNorm = sqrt(conv2(inputImage.*inputImage,ones(obj.windowSize,obj.windowSize),'same'));
            
            outputImage = inputImage-windowedMean;
            outputImage(windowedNorm>1) = outputImage(windowedNorm>1)./windowedNorm(windowedNorm>1);
        end
        
        % Convolve the image with each filter in the filterbank and apply
        % response threshold and saturation
        function FilterImage(obj, inputImage)
            filterOutputSize = [size(inputImage,1)-obj.filterParameters(1,1)+1 size(inputImage,2)-obj.filterParameters(1,1)+1];
            obj.filterResponses = zeros(filterOutputSize(1), filterOutputSize(2),obj.nFilters);
            
            for filterIndex = 1:length(obj.filterModels)
                fr = conv2(inputImage,obj.filterModels{filterIndex},'valid');
                fr(fr<0) = 0;
                fr(fr>1) = 1; 
                obj.filterResponses(:,:,filterIndex) = fr;
            end
        end
        
        % Performs divise normalization of the filter output
        function DoOutputNormalization(obj)
            meanWindow = ones(obj.windowSize,obj.windowSize,obj.nFilters)./(obj.windowSize*obj.windowSize*obj.nFilters);
            windowedMean = convn(obj.filterResponses,meanWindow,'same');
            windowedNorm = sqrt(convn(obj.filterResponses.*obj.filterResponses, ones(size(meanWindow)),'same'));
            
            % Pick the central part of the convolution
            windowedMean = squeeze(windowedMean(:,:,ceil(obj.nFilters/2)));
            windowedNorm = squeeze(windowedNorm(:,:,ceil(obj.nFilters/2)));
            
            obj.filterResponses = obj.filterResponses - repmat(windowedMean,1,1,obj.nFilters);
            obj.filterResponses(windowedNorm>1) = obj.filterResponses(windowedNorm>1)./windowedNorm(windowedNorm > 1);
        end
    end
end