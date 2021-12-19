classdef CommonTests < matlab.unittest.TestCase
    %ROBOTTESTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods(Test)
        function getEntryPointCoordFrameTest(testCase)
            tumor = [2,2,0];
            window = [3,2,0];
            result = getEntryPointCoordFrame(tumor,window,0.5);
            rot = getRot(result);
            
            ref = dot(rot(1,:)', rot(2,:));
            verifyEqual(testCase, 0, ref, 'AbsTol', 1e-5, ...
                'vectors are not orthogonal');
            ref = dot(rot(1,:)', rot(3,:));
            verifyEqual(testCase, 0, ref, 'AbsTol', 1e-5, ...
                'vectors are not orthogonal');
            ref = dot(rot(2,:)', rot(3,:));
            verifyEqual(testCase, 0, ref, 'AbsTol', 1e-5, ...
                'vectors are not orthogonal');
        end
        
        function getNeedletipToEntryPointTfTest(testCase)
            tumor = [4,6,0];
            window = [5,5,0];
            tfNeedle = eye(4);
            tf = getNeedletipToEntryPointTf( tumor, window, tfNeedle);
            tf
        end
    end
end
