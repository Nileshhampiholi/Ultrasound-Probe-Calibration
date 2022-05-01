function tfMatInv = invTfMat(tfMat)
tfMatInv = [tfMat(1:3, 1:3)' -tfMat(1:3, 1:3)'*tfMat(1:3, 4);
            0   0   0         1];
end