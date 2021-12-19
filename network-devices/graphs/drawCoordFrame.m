function drawCoordFrame( tfMat,name )
%DRAWCOORDFRAME draws versor axes of the coordinate frame in 3d
    xx = tfMat(1,1); xy = tfMat(2,1); xz = tfMat(3,1);
    yx = tfMat(1,2); yy = tfMat(2,2); yz = tfMat(3,2);
    zx = tfMat(1,3); zy = tfMat(2,3); zz = tfMat(3,3);
    ox = tfMat(1,4); oy = tfMat(2,4); oz = tfMat(3,4);
    quiver3(ox,oy,oz,xx,xy,xz,50,'MaxHeadSize',5,'LineWidth',2,'Color','r'); hold on;
    quiver3(ox,oy,oz,yx,yy,yz,50,'MaxHeadSize',5,'LineWidth',2,'Color','g'); hold on;
    quiver3(ox,oy,oz,zx,zy,zz,50,'MaxHeadSize',5,'LineWidth',2,'Color','b'); hold on;
    legend('x','y','z')
    text(ox,oy,oz,name);
    scatter3(ox,oy,oz,50,'filled');
end

