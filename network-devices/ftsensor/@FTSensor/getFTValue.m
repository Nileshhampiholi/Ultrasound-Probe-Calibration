function [msg] = getFTValue(self)

msg = self.sendReceive(sprintf('getFTValue'));


end