cambar = Cambar(IPaddresses.Cambar_Lab,3000);
cambar.loadLocator('stylus2');

a = [];
for i=1:20
    i
    disp('Are you ready?');
    pause();
    [tf,T] = cambar.getLocatorTransformMatrix('stylus2');
    a = [a; [T 1 reshape(tf',1,16)]];
end




%% Write the results into a data
d = datetime('today');
date = datestr(d);

fulltime = clock();

timestamp = strcat(date,',',num2str(fulltime(4)),'.',num2str(fulltime(5)));

filename = strcat('a',timestamp,'.txt');
fileID = fopen(filename,'wt'); 
 
for ii = 1:size(a,1)
    fprintf(fileID,'%g\t',a(ii,:));
    fprintf(fileID,'\n');
end

fclose(fileID);