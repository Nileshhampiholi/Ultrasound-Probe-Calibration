function [msg] = setBiasVector(self)

msg = self.sendReceive(sprintf('setBiasVector'));


end