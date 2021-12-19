function successful = moveToCoordinatesLIN(self,coordinates)
hom = self.getPositionHomRowWise();
hom(1,4) = coordinates.x;
hom(2,4) = coordinates.y;
hom(3,4) = coordinates.z;
successful = self.moveLINToHomRowWise(hom);

