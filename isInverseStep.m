function [result] = isInverseStep( step1, step2 )

    inverseSteps = zeros(8);
    inverseSteps(1, 3) = 1;
    inverseSteps(3, 1) = 1;
    inverseSteps(2, 4) = 1;
    inverseSteps(4, 2) = 1;
    inverseSteps(5, 5) = 1;
    inverseSteps(6, 7) = 1;
    inverseSteps(7, 6) = 1;
    
    [~, I1] =  max(step1);
    [~, I2] =  max(step2);
    
    result = inverseSteps(I1, I2);
    
end

