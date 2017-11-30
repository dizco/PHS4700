function [phiM, thetaN] = EchantillonAngle(rangeVertical, rangeHorizontal, M, N)
    phiMin = rangeHorizontal(1);
    phiMax = rangeHorizontal(2);
    thetaMin = rangeVertical(1);
    thetaMax = rangeVertical(2);
    
    phiM = phiMin + ( ( (phiMax - phiMin) / (2 * M) ) * (2 * m - 1) );
    thetaN = thetaMin + ( ( (thetaMax - thetaMin) / (2 * N) ) * (2 * n - 1) );
end