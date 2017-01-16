function [result] = isValidStep(step, mapCrop)
%the step is OK, if it is not empty
%and moves to a good location

    result = 1;
    
    if isMove(step)
        if not(isValidMove(step,mapCrop))
            result = 0;
        end
    end
    
    if sum(step)==0
        result = 0;
    end
    
end

