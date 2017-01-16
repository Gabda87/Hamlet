function [mapCrop] = cropMap(map, pos1, pos2, rotation, cropSize)


    halfCropSize = (cropSize - 1) /2;
    pos1 = min(max(halfCropSize + 1, pos1), size(map,1) - halfCropSize);
    pos2 = min(max(halfCropSize + 1, pos2), size(map,2) - halfCropSize);
    mapCrop = map((pos1 - halfCropSize):(pos1 + halfCropSize), (pos2 - halfCropSize):(pos2 + halfCropSize), :);
    
    for i=1:size(mapCrop,3)
        mapCrop(:,:,i) = rot90(mapCrop(:,:,i), rotation);
    end

end

