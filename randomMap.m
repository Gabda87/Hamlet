function [map] = randomMap(halfSize, features, probability1, probability2)

    size = 2 * halfSize +1;
    mid = halfSize + 1;
    map1 = rand(size, size, 1);
    map1 = (map1 > probability1);
    map2 = rand(size, size, 1);
    map2 = (map2 > probability2);
    
    map(:, :, 1) = map1(:, :, 1);
    map(:, :, 2) = map2(:, :, 1);
    
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

