function matrix = getPositionHomRowWise(self)
% err = true;
% while err
%     msg = self.sendReceive('GetPositionHomRowWise');
%     disp(msg);
%     if (size(msg) == -1)
%         error('No Homog Row-wise position received!');
%     else
%         splitted = strsplit(msg,'\n');
%         matr = splitted(end-1);
%         C = textscan(matr{1},'%f');
%         matr_ent = C{:};
%         if length(matr_ent) ~= 12
%             continue;
%         end
%         matrix=reshape(matr_ent, 4, 3)';
%         err = false;
%     end
% end

matrix = NaN;
i = 1;
while any(isnan(matrix(:)))
    if self.verbose
        fprintf('Try %d\n', i);
    end
    msg = self.sendReceive('GetPositionHomRowWise');
    mssgSplit = strsplit(strtrim(msg),' ');
    if length(mssgSplit) == 12
        matrix = reshape(str2double(mssgSplit),4,3)';
    end
    i = i + 1;
end
self.lastPose = matrix;