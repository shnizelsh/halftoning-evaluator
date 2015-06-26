function [ config ] = get_default_config( )
%get_default_config returns the default configuration


%% configuration setup

config.dpi=300;
config.print_size_inches=[5 5];
config.write_head_size=20;
config.max_gap=4;
config.max_dot_size_variation=0.2;
config.banding_frequency=0.2; %3
config.max_shifting=32;
config.icc='bin/SWOP2013C5.icc';
end

