function [rotation] = rotateRotation(rotation,  step)

%5: back
%6: right
%7: left


%for can be ommited with  MatLab R2016
%map = rot(map,2) works with multidimensional arrays

    [M, I] = max(step);

    switch I
        case 5
            rotation = rotation + 2;
        case 6
            rotation = rotation + 1;
        case 7
            rotation = rotation - 1;
    end

    rotation = mod(rotation, 4);
    
end

