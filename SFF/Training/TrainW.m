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
% AND
% Hua-wen Chang, Ming-hui Wang, Shu-qing Chen et al., "Sparse feature fidelity for
% image quality assessment," in Proceedings of 21st International Conference on
% Pattern Recognition (ICPR), Tsukuba, Japan, November 2012, pp. 1619-1622. 
% ----------------------------------------------------------------------
% TRAINING OF FEATURE DETECTOR (Simple Cell Matrix)
%
% INPUT variables:
% sampleSize = 18000;   %  Number of sample patches
% patchSize = 8;        %  Patch size of samples
% retainedDim = 8;      %  Number of features computed
%
% OUTPUT variables:
% W                     %  Feature detector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function W = TrainW(sampleSize, patchSize, retainedDim)

randn('state',0);
rand('state',0);

disp('Sampling data')
X = sampleimages(sampleSize,patchSize);
disp('Removing DC component')
X = removeDC(X);
disp('Doing PCA and whitening data')
[V,E,D] = pca(X);
Z = V(1:retainedDim,:)*X;

disp('Start training. ')
W_w = ica(Z,retainedDim);

%transform back to original space from whitened space
W = W_w*V(1:retainedDim,:);

save('W.mat','W');
fprintf('\n Done!\n');
