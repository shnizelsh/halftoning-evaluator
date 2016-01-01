
function save_results(runID,elapsedTime,algorithm,printer,method,g,b,s,im,im_original,im_path)
%% save_results function is saving the test result to a csv file
%
% Parameters:
%   runID - An aidentifier used in the filename to be used in the directory
%           name
%   elapsedTime - the test's ellapsed time
%   algorithm - The algoritm object used in the directory name
%   printer - The printer used in the test
%   method - the method used to create the filename
%   g - thew graininess score
%   b - the banding score
%   s - the similarity score
%   im - the result image
%   im_original - the original image
%   im_path - The original image path

 full_path_result=get_file_path(runID,im_path,printer.config,algorithm,'_result_',method);
 imwrite(im,full_path_result,'Compression','lzw');
 full_path_input=get_file_path(runID,im_path,printer.config,algorithm,'_input_',method);
 imwrite(im_original,full_path_input,'Compression','lzw');


results_file = 'results/results.csv';
if(~exist(results_file,'file'))
    fid = fopen(results_file,'w+');
    fprintf(fid, 'Date,Processing time (sec),algorithm,method,printer,dpi,print_size_inches,max_gap,write_head_size,max_dot_size_variation,banding_frequency,max_shifting,graininess,banding,similarity,image path \r\n');
    fclose(fid);
end
fid = fopen(results_file,'a');

fprintf(fid, '%s, %s, %s, %s, %s, %d, %dx%d, %d, %d, %.2f, %.2f, %d, %s, %s, %s, %s \r\n',datestr(now),num2str(elapsedTime),func2str(algorithm.func),method,...
    printer.Name,printer.config.dpi,printer.config.print_size_inches(1),printer.config.print_size_inches(2), ...
    printer.config.max_gap,printer.config.write_head_size,printer.config.max_dot_size_variation,printer.config.banding_frequency,...
    printer.config.max_shifting,num2str(g), num2str(b),num2str(s),full_path_result);
fclose(fid);
end

