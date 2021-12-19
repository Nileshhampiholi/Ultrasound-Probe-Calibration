function [ tf ] = getEntryPointCoordFrame( tumor,window,ratio )
%GETENTRYPOINTCOORDFRAME
    l = tumor - window;
    entrypoint = window - ratio*(l);
    z = l/norm(l);
    f = [1; 1; 3];
    while(dot(f,z)==0)
        f = [rand(); rand(); rand()];
    end
    x = cross(z,f);
    x = x/norm(x);
    y = -cross(x,z);
    R = [x' y' z'];
    tf = [R entrypoint'];
    tf = reshape(tf,3,4);
end

