% Sparse Feature Fidelity (SFF)
% Training on image samples by ICA
% FastICA (Aapo Hyvarinen)
% INPUT:
% Z  : whitened image patch data
% n  : number of independent components to be estimated
function W = ica(Z,n)

%create random initial value of W, and orthogonalize it
W = orthogonalizerows(randn(n,size(Z,1))); 

%read sample size from data matrix
N=size(Z,2);

iter = 0;
notconverged = 1;

while notconverged && (iter<2000) %maximum of 2000 iterations
    iter=iter+1;
  
    % Store old value
    Wold=W;        

    % Compute estimates of independent components 
    Y=W*Z; 
 
    % Use tanh non-linearity
    gY = tanh(Y);
    
    % This is the fixed-point step. 
    % Note that 1-(tanh y)^2 is the derivative of the function tanh y
    W = gY*Z'/N - (mean(1-gY'.^2)'*ones(1,size(W,2))).*W;    
    
    % Orthogonalize rows or decorrelate estimated components
    W = orthogonalizerows(W);

    % Check if converged by comparing change in matrix with small number
    % which is scaled with the dimensions of the data
    if norm(abs(W*Wold')-eye(n),'fro') < (1e-8) * n;
        notconverged=0;
    end
    fprintf(' . ')
end








