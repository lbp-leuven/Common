# Description
Matlab implementation of the V1 model described in Pinto, Cox & DiCarlo(2008). Why is real-world visual object recognition hard? Plos Computational Biology

# Usage
```matlab
myModel = V1Model();

filterSize = 64;
orientation1 = 0;
orientation2 = 30;
sf = 1/64;
sigmas = [10 10];
phase = 0;

myModel.AddFilter(filterSize, orientation1, sf, sigmas,0);
myModel.AddFilter(filterSize, orientation2, sf, sigmas,0);

inputImage = imread(someImageFile);
filterOutput = myModel.ProcessImage(inputImage);
```
