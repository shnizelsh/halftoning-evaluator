% =================================================================
%  Sparse Feature Fidelity (SFF) Version 2.0
%  Copyright(c) 2013  Hua-wen Chang
%  All Rights Reserved.
% ----------------------------------------------------------------
% Please refer to the following paper
%
% Hua-wen Chang, Hua Yang, Yong Gan, and Ming-hui Wang, "Sparse Feature Fidelity
% for Perceptual Image Quality Assessment", IEEE Transactions on Image Processing,
% vol. 22, no. 10, pp. 4007-4018, October 2013
% ----------------------------------------------------------------------
% GET SAMPLE PATCHES FROM NATURAL IMAGES
% INPUT variables:
% samples            total number of patches to take
% patchSize          patch width in pixels
% OUTPUT variables:
% X                  the image patches as column vectors
%
% There are two sets of images for sampling and training data1 and data2
% =================================================================


function X = sampleimages(samples, patchSize)

dataNum = 9;
getsample = floor(samples/dataNum);
patchDim = (patchSize^2)*3;
X = zeros(patchDim,samples);

sampleNum = 1;
for i=(1:dataNum)
    if i==dataNum, getsample = samples-sampleNum+1; end
    
    I = imread(['data1/' num2str(i) '.jpg']);
    I = double(I);
    % Sample patches in random locations
    sizex = size(I,2);
    sizey = size(I,1);
    posx = floor(rand(1,getsample)*(sizex-patchSize-2))+1;
    posy = floor(rand(1,getsample)*(sizey-patchSize-1))+1;

    for j=1:getsample
        X(:,sampleNum) = reshape( I(posy(1,j):posy(1,j)+patchSize-1, posx(1,j):posx(1,j)+patchSize-1, 1:3),[patchDim 1]);
        sampleNum=sampleNum+1;
    end
end
