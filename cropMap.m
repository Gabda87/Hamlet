function [mapCrop] = cropMap(map, pos1, pos2, rotation)

    cropSize = 3;
    pos1 = min(max(cropSize + 1, pos1), size(map,1) - cropSize);
    pos2 = min(max(cropSize + 1, pos2), size(map,2) - cropSize);
    mapCrop = map((pos1 - cropSize):(pos1 + cropSize), (pos2 - cropSize):(pos2 + cropSize), :);
    
    for i=1:size(mapCrop,3)
        mapCrop(:,:,i) = rot90(mapCrop(:,:,i), rotation);
    end

end

