% =================================================================
%  Sparse Feature Fidelity (SFF)
%  on TID2008 database
%  Copyright(c) 2013  Hua-wen Chang
%  All Rights Reserved.
% ----------------------------------------------------------------------
% Please refer to the following paper
%
% Hua-wen Chang, Hua Yang, Yong Gan, and Ming-hui Wang,"Sparse Feature Fidelity
% for Perceptual Image Quality Assessment", IEEE Transactios on Image Processing,
% vol. 22, no. 10, pp. 4007-4018, October 2013
% ----------------------------------------------------------------------
% example: [s,m]=TID2008();
% =================================================================

 function [OB,metrics] = TID2008()

load ('TID2008.mat');
load('W.mat');

Score = zeros(1700,1);
h = waitbar(0,'Please wait...');
iPoint = 0;

for iRef = 1:25
    %READ A REFERENCE IMAGE
    imNameRef = num2str(iRef,'%02d');
    Ir = imread(['D:\IMDB\tid2008\reference_images\I' imNameRef '.BMP']);
    %READ A DISTORTED IMAGE
    for iDis = 1:17
        imNameDis = ['_' num2str(iDis,'%02d')];
        for iLevel = 1:4
            Id = imread(['D:\IMDB\tid2008\distorted_images\I' imNameRef imNameDis '_' num2str(iLevel) '.BMP']);
            iPoint = iPoint+1;
            Score(iPoint) = SFF(Ir,Id,W);

            waitbar(iPoint/1700);
        end
    end   
end
close(h);

SB = tid_MOS;               % Subjective Score
OB = Score;                 % Objective Score

metric_1 = corr(SB, OB, 'type', 'pearson');     % Pearson linear correlation coefficient (without mapping)
metric_2 = corr(SB, OB, 'type', 'spearman');    % Spearman rank-order correlation coefficient
metric_3 = corr(SB, OB, 'type', 'kendall');     % Kendall rank-order correlation coefficient
metrics = [metric_1;metric_2;metric_3];
figure,scatter(OB,SB,'*');

