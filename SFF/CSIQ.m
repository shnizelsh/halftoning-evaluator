% =================================================================
%  Sparse Feature Fidelity (SFF)
%  on CSIQ database
%  Copyright(c) 2013  Hua-wen Chang
%  All Rights Reserved.
% ----------------------------------------------------------------------
% Please refer to the following paper
%
% Hua-wen Chang, Hua Yang, Yong Gan, and Ming-hui Wang, "Sparse Feature Fidelity
% for Perceptual Image Quality Assessment", IEEE Transactions on Image Processing,
% vol. 22, no. 10, pp. 4007-4018, October 2013
% ----------------------------------------------------------------------
% example: [s,m]=CSIQ();
% =================================================================

 function [OB,metrics] = CSIQ()
 
load('CSIQ.mat');   % load database information and DMOS data
load('W.mat');      % load the feature detector, W

Score = zeros(866,1);
h = waitbar(0,'Please wait...');
for iPoint = 1:866
    %READ A REFERENCE IMAGE
    Ir = imread(['D:\IMDB\CSIQ\src_imgs\' csiq_imTitle{iPoint,2} '.png']);
    %READ A DISTORTED IMAGE
    Id = imread(['D:\IMDB\CSIQ\dst_imgs\' csiq_imTitle{iPoint,1} '\' csiq_imTitle{iPoint,2} '.' csiq_imTitle{iPoint,1} '.' num2str(csiq_imDMOS(iPoint,1)) '.png']);

    Score(iPoint) = SFF(Ir,Id,W);
    waitbar(iPoint/866);
end
close(h);

SB = csiq_imDMOS(:,2);      % Subjective Score
OB = Score;                 % Objective Score

metric_1 = corr(SB, OB, 'type', 'pearson');     % Pearson linear correlation coefficient (without mapping)
metric_2 = corr(SB, OB, 'type', 'spearman');    % Spearman rank-order correlation coefficient
metric_3 = corr(SB, OB, 'type', 'kendall');     % Kendall rank-order correlation coefficient
metrics = [metric_1;metric_2;metric_3];
figure,scatter(OB,SB,'*');
