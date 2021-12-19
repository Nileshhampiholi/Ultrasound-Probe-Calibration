function locator = loadLocator(self, name)
% LoadLocator  Loads the locator 'name'. Please make sure that locator
% exists at the path "C:\locators\<name>.xml" on the computer where the
% cambarserver is running.
%
% TCP/IP object associated with the CambarServer needs to be provided as
% well.
%   LoadLocator(jTcpObj, 'name')

locator = self.sendReceive(['LoadLocator ' name]); disp(locator);

if ~isempty(strfind(locator,'error')) || isempty(locator)
    error('Cannot load locator! Please restart the CambarServer.')
end

end