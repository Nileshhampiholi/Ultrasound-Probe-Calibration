classdef MatrixDiagnostics < matlab.unittest.diagnostics.Diagnostic
    %MATRIXDIAGNOSTICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        matrices
    end
    
    methods
        function diag = MatrixDiagnostics(matrices)
            % Constructor - construct a ProcessStatusDiagnostic
            %
            %   The ProcessStatusDiagnostic constructor takes an
            %   optional header to be displayed along with process
            %   information.
            if (nargin > 0)
                diag.matrices = matrices;
            end
        end
        
        function diagnose(diag)
            s = size(diag.matrices);
            str = ['Positions not reachable:' char(10)];
            for i=1:s(2);
                str = [str mat2str(diag.matrices{i},4) char(10)];
            end
            diag.DiagnosticResult = str;
        end
    end
    
end
