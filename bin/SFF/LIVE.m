% =================================================================
%  Sparse Feature Fidelity (SFF)
%  on LIVE database
%  Copyright(c) 2013  Hua-wen Chang
%  All Rights Reserved.
% ----------------------------------------------------------------------
% Please refer to the following paper
%
% Hua-wen Chang, Hua Yang, Yong Gan, and Ming-hui Wang, "Sparse Feature Fidelity
% for Perceptual Image Quality Assessment", IEEE Transactions on Image Processing,
% vol. 22, no. 10, pp. 4007-4018, October 2013
% ----------------------------------------------------------------------
% example: [s,m]=LIVE();
% =================================================================

 function [OB,metrics] = LIVE()
 
load('LIVE.mat');   % load database information and DMOS data
load('W.mat');      % load the feature detector, W

Score = zeros(779,1);
h = waitbar(0,'Please wait...');
i = 0;
for iPoint = 1:982
    if (live_imSTD(iPoint) == 0)
        continue;
    else
        %READ A REFERENCE IMAGE
        Ir = imread(['D:\IMDB\databaserelease2\refimgs\' live_imName{iPoint}]);
   
        %READ A DISTORTED IMAGE
        if (iPoint > 0)&&(iPoint <= 227)        % JPEG2000
            Id = imread(['D:\IMDB\databaserelease2\jp2k\img' num2str(iPoint) '.bmp']);
        elseif (iPoint > 227)&&(iPoint <= 460)  % JPEG
            Id = imread(['D:\IMDB\databaserelease2\jpeg\img' num2str(iPoint-227) '.bmp']);
        elseif (iPoint > 460)&&(iPoint <= 634)  % White Noise
            Id = imread(['D:\IMDB\databaserelease2\wn\img' num2str(iPoint-460) '.bmp']);
        elseif (iPoint > 634)&&(iPoint <= 808)  % Gaussian Blur
            Id = imread(['D:\IMDB\databaserelease2\gblur\img' num2str(iPoint-634) '.bmp']);
        elseif (iPoint > 808)&&(iPoint <= 982)  % Fast Fading
            Id = imread(['D:\IMDB\databaserelease2\fastfading\img' num2str(iPoint-808) '.bmp']);
        end
        i = i+1;
        Score(i) = SFF(Ir,Id,W);
    end
    waitbar(iPoint/982);
end
close(h);

SB = live_imDMOS;       % Subjective Score
OB = Score;             % Objective Score

metric_1 = corr(SB, OB, 'type', 'pearson');     % Pearson linear correlation coefficient (without mapping)
metric_2 = corr(SB, OB, 'type', 'spearman');    % Spearman rank-order correlation coefficient
metric_3 = corr(SB, OB, 'type', 'kendall');     % Kendall rank-order correlation coefficient
metrics = [metric_1;metric_2;metric_3];
figure,scatter(OB,SB,'*');
