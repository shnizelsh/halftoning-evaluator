function [ algorithms ] = get_algorithms()
% This function is ised to define the algorithms to test
% The funtion returns the halftoning algorithm list


screen_16uAlgo.func = @screen_16u; screen_16uAlgo.type = 'grayscale';
floydAlgo.func= @floyd; floydAlgo.type = 'grayscale';
am_screenAlgo.func = @am_screen; am_screenAlgo.type = 'cmyk';
stuckiAlgo.func = @stucki; stuckiAlgo.type = 'grayscale';
jarvisAlgo.func = @jarvis; jarvisAlgo.type = 'grayscale';
bnoiseAlgo.func = @bnoise; bnoiseAlgo.type = 'grayscale';

algorithms = {floydAlgo;
              am_screenAlgo;                          
              screen_16uAlgo;                
              stuckiAlgo;
              jarvisAlgo;              
              bnoiseAlgo};

end

