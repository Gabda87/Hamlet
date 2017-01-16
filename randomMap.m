function [map] = randomMap(halfSize, features, probability)

    size = 2 * halfSize +1;
    mid = halfSize + 1;
    map = rand(size, size, features);
    map = (map > probability);
    map(mid, mid, :) = 0;
    
    goodMap = isPassableTile(map(mid-1, mid, :)) | ...
              isPassableTile(map(mid+1, mid, :)) | ...
              isPassableTile(map(mid, mid-1, :)) | ...
              isPassableTile(map(mid, mid+1, :));
    
    %the map is good if you can move out from the middle point
          
    if not(goodMap)
        
        map = randomMap(halfSize, features, probability);
        
    end

end

