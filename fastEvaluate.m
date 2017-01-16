function [score, picked] = fastEvaluate(map, nnParams, patternNumber,...
    hiddenLayerSize_2, commandSize, cropSize)

halfMapSize = (size(map, 1) - 1) / 2;

pos=[halfMapSize + 1; halfMapSize + 1];
%it is the middle of the map
rotation = 0;
%looking UP

mapCrop = cropMap(map, pos(1), pos(2), rotation, cropSize);
%we rotate the map istead of the NPC
%the NPC is always looking UP in mapCrop

picked = 0;
%the number of apples
score = 0;
%invalidStep = 0;
%validStep = 0;

forwardStep = zeros(commandSize, 1);
forwardStep(1) = 1;
continuousRotation = 0;
previuousStep = [0, 0, 0, 0, 0, 0, 0, 1]; %a pick, because there is no inverse for pick

for i = 1:500 
    
    if map(pos(1), pos(2), 1) == 1
        score = score - 0.5;
    end
    
    step = nextStep(nnParams, mapCrop, patternNumber, hiddenLayerSize_2, commandSize);
    %decides the next step (nothing random so far)
    
    if isInverseStep(step, previuousStep)
        score = score - 5;
        break;
    end
    
    nextTile = pos + moveDirection(forwardStep, rotation);
    
    if map(nextTile(1), nextTile(2), 1) == 1
        
        %we pick the apple if it is in front of us
        map(nextTile(1), nextTile(2), 1) = 0;
        picked = picked + 1;
        continuousRotation = -1;
        
        if isPick(step) == 1
            score = score + 6;
        else
            score = score + 1;
        end
    else
        if isPick(step) == 1
            break;
        end
    end
    
    if isRotate(step)
        
        rotation = rotateRotation(rotation, step);
        continuousRotation = continuousRotation + 1;
        
        if continuousRotation > 3    
            break;
        end
        
    end
    
    if isMove(step)
        
        continuousRotation = 0;
        
        if isValidStep(step, mapCrop) == 1
            pos = pos + moveDirection(step, rotation);
            %validStep = validStep + 1;
        else
            %invalidStep = invalidStep + 1;
            break;
        end
        
    end
    
    mapCrop = cropMap(map, pos(1), pos(2), rotation, cropSize);
    
    previuousStep = step;
    
end

end