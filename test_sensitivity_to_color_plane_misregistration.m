function test_sensitivity_to_color_plane_misregistration(runID, algorithm, config )
%% Testing the sensitivity of the printer to color plane misregistration

%% create printer
printer=LaserPrinter(config,true);
%printer=PerfectPrinter(config);

%% test the sensitivity for natural images
test_sensitivity(runID,algorithm,'color_plane_misregistration',printer,true);

%% test the sensitivity for test images
test_sensitivity(runID,algorithm,'color_plane_misregistration',printer,false);
end

