classdef RobotTests < matlab.unittest.TestCase
    %ROBOTTESTS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        robot
        elevator
    end
    
    methods(TestClassSetup)
        function connect(testCase)
            testCase.elevator = Elevator();
            testCase.elevator.play('Starting test.');
            testCase.robot = UR5(IPaddresses.Robot_VM);
        end
    end
    
    methods(TestClassTeardown)
        function disconnect(testCase)
            testCase.elevator.stop('Tests finished');
            testCase.robot.bye();
        end
    end
    
    methods(Test)
        inverseKinematics(testCase)
        forwardKinematics(testCase)
        moveToJointPositions(testCase)
        randomPointsInSphere(testCase)
        inverseKinematicsAdvanced(testCase)
        moveAlongLine(testCase)
    end
    
end
