function test_sensitivity_to_dot_size_variation(runID, algorithm ,config)
%% Testing the sensitivity of the printer to dot size variation

%% create printer
printer=LazerPrinter(config,false,true);

%% test the sensitivity for test images
test_sensitivity(runID, algorithm,'dot size variation',printer,false);

%% test the sensitivity for natural images
test_sensitivity(runID, algorithm,'dot size variation',printer,true);


end