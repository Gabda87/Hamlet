function picked = graphicEvaluate(npcName)

load('map1.mat','map');
halfMapSize = (size(map, 1) - 1) / 2;

myVars = {'chParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
load(strcat('NPCs\',npcName,'.mat'), myVars{:});

nnParams = chParams;

pos=[halfMapSize + 1; halfMapSize + 1];
%it is the middle of the map
rotation = 0;
%looking UP

mapCrop = cropMap(map, pos(1), pos(2), rotation, cropSize);
%we rotate the map istead of the NPC
%the NPC is always looking UP in mapCrop

picked = 0;
score = 0;
%the number of apples
invalidStep = 0;
validStep = 0;
rotationNumber = 0;

forwardStep = zeros(commandSize, 1);
forwardStep(1) = 1;
continuousRotation = 0;
previuousStep = [0, 0, 0, 0, 0, 0, 0, 1]; %a pick, because there is no inverse for pick

marker = 'b^';
marker = rotateMarker(marker, rotation);

subplot(1,2,2);
    spy(sparse(map(:,:,2)),'gs',4);
    hold on;

for i = 1:500
    
    subplot(1,2,1);
    hold off;
    spy(sparse(map(:,:,1)),'rs',4);
    hold on;
    plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
    subplot(1,2,2);
    handle = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
    
    
    
    drawnow;
    
    delete(handle)
    
    step = nextStep(nnParams, mapCrop, patternNumber, hiddenLayerSize_2, commandSize);
    
    if isInverseStep(step, previuousStep)
        score = score - 5;
        fprintf('It stepped back!\n');
        break;
    end
    
    %decides the next step (nothing random so far)
    [~, I] = max(step);
    %fprintf('Step %i: %i (isMove: %i, isRotation: %i)\n', i, I, isMove(step), isRotate(step))
    
    
    if map(pos(1), pos(2), 1) == 1
        score = score - 0.5;
    end
    
    nextTile = pos + moveDirection(forwardStep, rotation);
    
    if map(nextTile(1), nextTile(2), 1) == 1
        
        %we pick the apple if it is in front of us
        map(nextTile(1), nextTile(2), 1) = 0;
        picked = picked + 1;
        continuousRotation = 0;
        
        if isPick(step) == 1
            score = score + 6;
            fprintf('Apple picked!\n');
        else
            score = score + 1;
        end
    else
        if isPick(step) == 1
            fprintf('There were no apples to pick!\n');
            break;
        end
    end
    
    if isRotate(step)
        
        rotation = rotateRotation(rotation, step);
        marker = rotateMarker(marker, rotation);
        continuousRotation = continuousRotation + 1;
        rotationNumber = rotationNumber + 1;
        
        if continuousRotation > 8    
            fprintf('Rotation error!\n');
            break;
        end
        
    end
    
    
    
    if isMove(step)
        
        continuousRotation = 0;
        
        if isValidStep(step, mapCrop) == 1
            pos = pos + moveDirection(step, rotation);
            validStep = validStep + 1;
        else
            invalidStep = invalidStep + 1;
            break;
        end
        
    end
    
    mapCrop = cropMap(map, pos(1), pos(2), rotation, cropSize);
    
    previuousStep = step;
    
end

fprintf('%s: Invalid steps: %i; Valid steps: %i; Rotations: %i; Apples picked: %i; Score: %i\n'...
    ,npcName, invalidStep, validStep, rotationNumber, picked, score);

end