function send(self, msgIn)

% Writing to server.
jtcp('write', self.client, int8(msgIn));

% if self.verbose
%     self.displayCmdMsg(msgIn,'');
% end
end