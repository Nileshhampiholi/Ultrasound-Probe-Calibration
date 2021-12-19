function [ tf ] = getNeedletipToEntryPointTf( tumor, window, tfNeedleTip )
%getNeedletipToEntryPointTf
	tfEntryPoint = getEntryPointCoordFrame( tumor,window,0.5 );
    tfEntryPoint = [tfEntryPoint;
                    0 0 0 1];
    tf = tfEntryPoint*tfNeedleTip;
end

