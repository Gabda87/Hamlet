function [map] = rotateMap( map,  step)

%5: back
%6: right
%7: left


%for can be ommited with  MatLab R2016
%map = rot(map,2) works with multidimensional arrays

    [~, I] = max(step);

    for i=1:size(map(3))
        switch I
            case 5
                map(:,:,i) = rot90(map(:,:,i),2);
            case 6
                map(:,:,i) = rot90(map(:,:,i),1);
            case 7
                map(:,:,i) = rot90(map(:,:,i),-1);
        end
    end

end

