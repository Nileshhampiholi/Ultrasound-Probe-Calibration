function [speed, unit] = getSpeed(self)
msg = self.sendReceive('GetSpeed');
speed = textscan(msg,'%f');
speed = speed{1};
ind = regexp(msg,'[a-z]');
unit = msg(ind(1):end);
end