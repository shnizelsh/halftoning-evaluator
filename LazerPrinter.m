classdef LazerPrinter < PerfectPrinter
    % Lazer Printer
    %   This printer prints with artifacts
    
    properties
        use_color_plane_misregstration=false;
        use_dot_size_variation=false;
        use_write_head_banding=false;
        SFF_results=[];
        graininess_results=[];
        banding_results=[]
    end
    
    methods
        
        %% Constructor
        function obj = LazerPrinter(config,use_color_plane_misregstration,use_dot_size_variation,use_write_head_banding)
            
            if(~exist('use_color_plane_misregstration','var'))
                use_color_plane_misregstration=false;
            end
            if(~exist('use_dot_size_variation','var'))
                use_dot_size_variation=false;
            end
            if(~exist('use_write_head_banding','var'))
                use_write_head_banding=false;
            end
            
            obj@PerfectPrinter(config);
            obj.Name = 'Lazer Printer';
            
            obj.use_color_plane_misregstration = use_color_plane_misregstration;
            obj.use_dot_size_variation = use_dot_size_variation;
            obj.use_write_head_banding = use_write_head_banding;
        end
                                      
        function [ im_result,s,g,b ] = print( obj, cmyk_image, compare_im )
            print@Printer(obj);
            
            if(obj.use_write_head_banding)
                blockSizeX=size(cmyk_image,1);
                blockSizeY=size(cmyk_image,2)/4;
            else
                blockSizeX=3; % 3 lines + padding
                blockSizeY=size(cmyk_image,2); % entire row (number of columns) + padding
            end
            
            obj.SFF_results=[];
            obj.graininess_results=[];
            obj.banding_results=[];
            
            im_result = blockproc(cmyk_image,[blockSizeX blockSizeY],...
                @(block)obj.print_internal(block,compare_im),'BorderSize',[10 10]);
            
            s=mean(obj.SFF_results);
            g=mean(obj.graininess_results);
            b=mean(obj.banding_results);
            
            %% note: pad-partial-blocks make the output image larger than the input
            %im_result = blockproc(cmyk_image,[blockSizeX blockSizeY],@obj.print_internal,'BorderSize',[10 10],'PadPartialBlocks',true);
        end
        
        function [ im_result ] = print_internal( obj, block , compare_im )
            
            cmyk_image = block.data;
            drop = obj.last_drop;
            if(obj.use_dot_size_variation)
                sf = obj.calculate_drop_scale_factor(block);
                drop = imresize(drop,sf);
            end
            max_drop = max(drop(:));
            phase = floor(obj.samples/2);
            printed = zeros(size(cmyk_image,1)*obj.samples,size(cmyk_image,2)*obj.samples,size(cmyk_image,3));
            
            for i=1:size(cmyk_image,3)
                current=cmyk_image(:,:,i);
                us_image = upsample(upsample(current,obj.samples,phase)',obj.samples,phase)';
                if(obj.use_write_head_banding)
                    us_image = obj.simulate_use_write_head_banding(us_image);
                end
                result=conv2(single(us_image),drop,'full');
                result(result>max_drop)=max_drop;
                cropped = result(round(size(drop,1)/2):end-floor(size(drop,1)/2), round(size(drop,2)/2):end-floor(size(drop,2)/2));
                printed(:,:,i)= cropped;
            end
            im_result = printed;
            im_result = obj.degrade(im_result,block);
            im_result = imresize(im_result,1/obj.samples,'box','Antialiasing',true);
        end
        
        
        %% calculate drop scale factor, Used to simulate dor size variation        
        function [sf] = calculate_drop_scale_factor(obj,block)
            max_dot_increase = obj.config.max_dot_size_variation;
            bands_freq=obj.config.banding_frequency;
            sf=1+max_dot_increase*sind(mod(block.location(1)*bands_freq,180));
        end
        
        %% simulate color plane misregstration
        function [im_result]= degrade(obj,cmyk_image,block)
            
            if(obj.use_color_plane_misregstration)
                C = cmyk_image(:,:,1);
                perc = block.location(1) / block.imageSize(1); % 0.0 .. 1.0
                two_shifts=obj.config.max_shifting*2;
                shift=round(perc*two_shifts-obj.config.max_shifting);   % -32 .. 32                              
                C = circshift(C',shift); % shift columns (X axis)
                C=C';
                cmyk_image(:,:,1)=C;
            end
            im_result=cmyk_image;
        end
        
        %% simulate write head banding
        function [ im_result ] = simulate_use_write_head_banding(obj,cmyk_image)
            im=cmyk_image(:,:,1);
            
            % printer's head size (in pixels)
            head_size=obj.config.write_head_size*obj.samples;
            
            % maximal gap (in pixels)
            max_gap=obj.config.max_gap;
            
            res=uint8(zeros(size(im,1),size(im,2)));
            p=1;
            n=size(im,1);
            from=1;
            to=from+head_size;
            num_of_gaps=ceil((n/head_size)/2)-1;
            num_of_bands=floor(n/head_size);
            remainder=mod(n,head_size);
            res(end-remainder+1:end,:)=im(end-remainder+1:end,:);
            q=1/num_of_gaps;
            i=1;
            j=(num_of_bands-1)*head_size+1;
            from2=j;
            to2=from2+head_size;
            for k=1:2:num_of_bands
                % copy top down
                res(from:to-1,:)=uint8(res(from:to-1,:))+uint8(im(i:i+head_size-1,:));
                
                if(i>=j)
                    break;
                end
                
                % copy down top
                res(from2:to2-1,:)=uint8(res(from2:to2-1,:))+uint8(im(j:j+head_size-1,:));
                
                %update vars for next interation
                gap=floor(max_gap*p);
                from=to+gap;
                to=from+head_size;
                to2=from2+gap;
                from2=to2-head_size;
                i=i+head_size;
                j=j-head_size;
                p=p-q;
            end
            
            res(res>1)=1;
            cmyk_image(:,:,1)=res;
            im_result=cmyk_image;
        end
    end
    
end

