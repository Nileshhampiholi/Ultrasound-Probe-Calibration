function msgOut = receive(self)

msgOut = char(jtcp('read', self.client));
% if self.verbose
%     self.displayCmdMsg(msgIn,'');
% end
end