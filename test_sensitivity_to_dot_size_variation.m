function test_sensitivity_to_dot_size_variation(runID, algorithm ,config)
%% Testing the sensitivity of the printer to dot size variation

%% create printer
printer=LaserPrinter(config,false,true);
%printer=PerfectPrinter(config);

%% test the sensitivity for test images
test_sensitivity(runID, algorithm,'dot size variation',printer,false);

%% test the sensitivity for natural images
test_sensitivity(runID, algorithm,'dot size variation',printer,true);


end