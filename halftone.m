function [ input_image ] = halftone( input_image ,halftone_algorithm)
% Perform the halfoninig function on the given image with the given
% algorithm.
%
%   input_image - the given image
%   halftone_algorithm - halftone_algorithm object hold the a pointer to
%                        the halftone function and the halftone type (cmyk,
%                        rgb, other)
%
%   return value - the halftoned image


disp('begin haltoning:');
func = halftone_algorithm.func;
type = halftone_algorithm.type;

switch type
    
    case 'cmyk'
        input_image = halftone_cmyk(input_image,func);
        
    case 'rgb'
        input_image = halftone_rgb(input_image,func);
        
    otherwise
        input_image = halftone_seperatly(input_image,func);
end

disp('finish haltoning:');

end

% Performs the halfoninig function on each color plane
function [ input_image ] = halftone_seperatly( input_image,func)
color_planes = size(input_image,3);
for i=1:color_planes
    try
        if(isa(input_image,'double'))
            input_image(:,:,i)=func(input_image(:,:,i));
        else
            input_image(:,:,i)=func(double(input_image(:,:,i))./255);
        end
    catch err
        disp(err.message);
    end
end
end

% Performs the halfoninig function on all color planes (RGB)
function [ input_image ] = halftone_rgb(input_image,func)

if(size(input_image,3)==4)
    input_image=cmyk2rgb(input_image);
end

try
    input_image=func(double(input_image)./255);
catch err
    disp(err.message);
end

end

% Performs the halfoninig function on all color planes (CMYK)
function [ input_image ] = halftone_cmyk(input_image,func)

try
    if(isa(input_image,'double'))
        input_image=uint8(func(input_image));
    else
        input_image=uint8(func(double(input_image)./255));
    end
catch err
    disp(err.message);
end

end

