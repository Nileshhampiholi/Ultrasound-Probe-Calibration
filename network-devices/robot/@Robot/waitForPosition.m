function waitForPosition(self, position)
if(all(size(position) == [1,6]))
    position = position';
end
currentPosition = self.getJointPositions();
while(sum(abs(currentPosition-position)) > 1e-2)
    i = 0;
    while(size(self.client.outputStream) == 0)
        i = i + 1;
        if(mod(i, 10))
            disp('Waiting for positioning...');
        end
    end
    
    pause(0.5);
    currentPosition = self.getJointPositions();
end
end