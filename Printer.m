classdef Printer<handle
    
    properties      
        config
        Name = 'base printer'        
    end
    
    methods
        %% Constructor
        function obj = Printer(config)
            obj.config=config;
        end
        
        %% print method
        function [ im_result, s ] = print( obj, cmyk_image, original_im )            
            disp (['printing using ' obj.Name]);            
        end
        
        %% degrade
        function [im_result]= degrade(obj,cmyk_image)
            im_result=cmyk_image;
        end
    end
end