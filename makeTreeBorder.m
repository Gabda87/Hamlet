function [map] = makeTreeBorder(map, borderWidth)

    map(1:borderWidth+1      , :                    , 2) = 1;
    map((end-borderWidth):end, :                    , 2) = 1;
    map(:                    , 1:borderWidth+1      , 2) = 1;
    map(:                    , (end-borderWidth):end, 2) = 1;
    %fill the edge with ones
    
    map(1:borderWidth+1      , :                    , 1) = 0;
    map((end-borderWidth):end, :                    , 1) = 0;
    map(:                    , 1:borderWidth+1      , 1) = 0;
    map(:                    , (end-borderWidth):end, 1) = 0;
    %clear any apple outside
    
    if borderWidth>2 
        borderWidth = borderWidth-1;

        map(1:borderWidth+1      , :                    , 2) = 0;
        map((end-borderWidth):end, :                    , 2) = 0;
        map(:                    , 1:borderWidth+1      , 2) = 0;
        map(:                    , (end-borderWidth):end, 2) = 0;
    end
    %remove the extra ones
    
end

