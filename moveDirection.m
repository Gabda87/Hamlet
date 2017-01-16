function [direction] = moveDirection(step, rotation)

%1: forward
%2: right
%3: backward
%4: left


    [~, I] = max(step);
    
    I = mod((I - 1 + rotation), 4) + 1;
    
    switch I
        case 1
            direction = [-1; 0];
        case 2
            direction = [ 0; 1];
        case 3
            direction = [ 1; 0];
        case 4
            direction = [ 0;-1];
        otherwise
            direction = [ 0; 0];
    end

end

