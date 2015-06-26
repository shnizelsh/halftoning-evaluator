function test_sensitivity_to_write_head_banding(runID, algorithm, config )
% Testing the sensitivity of the printer to write-head banding

%% create printer
printer=LazerPrinter(config,false,false,true);
%printer=PerfectPrinter(config);

%% test the sensitivity for natural images
test_sensitivity(runID, algorithm,'write_head_banding',printer,true);

%% test the sensitivity for test images
test_sensitivity(runID, algorithm, 'write_head_banding',printer,false);

end

