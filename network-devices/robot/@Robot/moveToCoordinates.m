function successful = moveToCoordinates(self,coordinates)
hom = self.getPositionHomRowWise();
hom(1,4) = coordinates.x;
hom(2,4) = coordinates.y;
hom(3,4) = coordinates.z;
configuration = self.getStatus();

thetas = self.backwardCalc( ...
    hom, ...
    configuration);

if(~isnan(thetas))
    self.moveToJointPositions(thetas);
    self.waitForPosition(thetas)
    successful = true;
else
    successful = false;
end
end