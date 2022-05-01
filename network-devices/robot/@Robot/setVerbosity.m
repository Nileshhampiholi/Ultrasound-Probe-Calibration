function setVerbosity( self, verbosity )
%SETVERBOSITY Summary of this function goes here
%   Detailed explanation goes here

self.sendReceive(['SetVerbosity ' num2str(verbosity)]);

end

