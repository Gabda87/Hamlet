function [marker] = rotateMarker(marker, rotation)

    switch rotation
        case 0
            marker(2)='^';
        case 1
            marker(2)='>';
        case 2
            marker(2)='v';
        case 3
            marker(2)='<';
    end

end

