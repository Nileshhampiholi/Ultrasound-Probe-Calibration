function possible = isPossible(self, matrix, configuration)
%ISPOSSIBLE Summary of this function goes here
%   Detailed explanation goes here
msg = self.sendReceive(['IsPossible ', num2str(reshape(matrix',1,12)), char(configuration)]);
possible = strcmp(strtrim(msg),'true');
end