function Y=removeDC(X)
% Subtract local mean value from each patch
Y = X-ones(size(X,1),1)*mean(X);
return;
