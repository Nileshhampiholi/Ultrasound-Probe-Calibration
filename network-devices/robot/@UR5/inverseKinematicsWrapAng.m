function thetas = inverseKinematicsWrapAng(H, config, thetasCurr)
thetas = UR5.inverseKinematics(H, config);
thetas = UR5.wrapJointAngles(thetas, thetasCurr);