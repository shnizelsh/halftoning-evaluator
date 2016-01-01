function [ L ] = calibrate(algorithm, printer)
% Calibrates the algorithm to address dot gain phenomenon.
% the algorithm returns Lookup table to apply on images.
%   algorithm - the algorithm you want to calibrate
%   printer (Optional) - printer to perform the calibration

if (~exist('printer', 'var'))
    config = get_default_config();
    printer=PerfectPrinter(config);
end

algoName =func2str(algorithm.func);
filename=['cal/cal_' algoName '.mat'];
if(exist(filename,'file'))
    load(filename,'-mat', 'L');
    return
end

disp('begin calibration');
LUT=zeros(256,2);
im = uint8(zeros(100,100,4));
for i=0:255
    im(:) = i;
    him=halftone(im , algorithm);
    pim=printer.print(him);
    LUT(i+1,:) = [i round(255*mean(pim(:)))];
    drawnow
end

L=lut_inverse(LUT(:,2));
%figure;plot(1:256,L);
save(filename, 'L');
disp('finish calibration');

