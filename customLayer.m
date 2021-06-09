% Custom layers

classdef customLayer << nnet.layer.Layer
    
    properties
        % Layer properties
    end
    
    properties(Learnable)
        % Layer learnable parameters
    end
    
    methods
        function layer = customLayer()
        end
        
        function [Z1] = predict(layer, X1)
        end
        
        function [] = forward()
        end
        
        function [] = backward()
        end
    end
end