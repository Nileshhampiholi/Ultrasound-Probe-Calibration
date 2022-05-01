function matrix = getExactPositionHomRowWise(self)

matrix = NaN;
i = 1;
while any(isnan(matrix(:)))
    if self.verbose
        fprintf('Try %d\n', i);
    end
    msg = self.sendReceive('GetExactPositionHomRowWise');
    mssgSplit = strsplit(strtrim(msg),' ');
    if length(mssgSplit) == 12
        matrix = reshape(str2double(mssgSplit),4,3)';
    end
    i = i + 1;
end
self.lastPose = matrix;