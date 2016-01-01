function main()
% This is the main function
% start your test here


close all;
algorithms = get_algorithms();
config = get_default_config();
i=0;

% test sensitivity to dot size variation for verious maximal dot sizes
for i=0:0.05:0.2
    config.max_dot_size_variation=i;
    runID=['max_dot_size_variation' num2str(i)];
    for j = 1: size(algorithms,1)
        algorithm = cell2mat(algorithms(j));
        test_sensitivity_to_dot_size_variation(runID,algorithm,config);
    end
end

% test sensitivity to color-plane misregistration for verious maximal shift
for i=0:5:50
    config.max_shifting=i;
    runID=['max_shifting' num2str(i)];
    for j= 1: size(algorithms,1)
        algorithm = cell2mat(algorithms(j));
        test_sensitivity_to_color_plane_misregistration(runID,algorithm,config);
    end
end

% test sensitivity to write head banding
config = get_default_config();
runID=['write_head_banding' num2str(i)];
for i= 1: size(algorithms,1)
    algorithm = cell2mat(algorithms(i));
    test_sensitivity_to_write_head_banding(runID,algorithm,config);
end


disp('finish all');
datestr(now)
end

