function picked = fastEvaluate(map, nnParams, patternNumber,...
    hiddenLayerSize_2, commandSize)

halfMapSize = (size(map, 1) - 1) / 2;

pos=[halfMapSize + 1; halfMapSize + 1];
%it is the middle of the map
rotation = 0;
%looking UP

mapCrop = cropMap(map, pos(1), pos(2), rotation);
%we rotate the map istead of the NPC
%the NPC is always looking UP in mapCrop

picked = 0;
%the number of apples
invalidStep = 0;
validStep = 0;

forwardStep = zeros(commandSize, 1);
forwardStep(1) = 1;

for i = 1:500
    
    nextTile = pos + moveDirection(forwardStep, rotation);
    
    if map(nextTile(1), nextTile(2), 1) == 1
        
        %we pick the apple if it is in front of us
        map(nextTile(1), nextTile(2), 1) = 0;
        picked = picked + 1;
        
    end
    
    step = nextStep(nnParams, mapCrop, patternNumber, hiddenLayerSize_2, commandSize);
    %decides the next step (nothing random so far)
    
    if isRotate(step)
        
        rotation = rotateRotation(rotation, step);
        
    end
    
    if isMove(step)
        
        if isValidStep(step, mapCrop) == 1
            pos = pos + moveDirection(step, rotation);
            validStep = validStep + 1;
        else
            invalidStep = invalidStep + 1;
        end
        
    end
    
    mapCrop = cropMap(map, pos(1), pos(2), rotation);
    
end

end