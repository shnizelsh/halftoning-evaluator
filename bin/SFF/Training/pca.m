% =================================================================
%  Sparse Feature Fidelity (SFF) Version 2.0
%  Copyright(c) 2013  Hua-wen Chang
%  All Rights Reserved.
% ----------------------------------------------------------------
% WHITENING AND DIMENSIONALITY REDUCTION BY PCA
%
% INPUT variables:
% X                  matrix with color image patches as columns
% OUTPUT variables:
% V                  whitening matrix
% E                  principal component transformation (orthogonal)
% D                  variances of the principal components
% =================================================================


function [V,E,D] = pca(X)

covarianceMatrix = X*X'/size(X,2);
[E, D] = eig(covarianceMatrix);
[dummy,order] = sort(diag(-D));
E = E(:,order);
d = diag(D); 
dsqrtinv = real(d.^(-0.5));
Dsqrtinv = diag(dsqrtinv(order));
D = diag(d(order));
V = Dsqrtinv*E';