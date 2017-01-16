function picked = evaluateNN(npcName)

load('map1.mat','map');
halfMapSize = (size(map, 1) - 1) / 2;

myVars = {'nnParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
load(strcat('NPCs\',npcName,'.mat'), myVars{:});

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
continuousRotation = 0;

marker = 'b^';
marker = rotateMarker(marker, rotation);

subplot(1,2,2);
    spy(sparse(map(:,:,2)),'gs',4);
    hold;

for i = 1:500
    
    subplot(1,2,1);
    hold off;
    spy(sparse(map(:,:,1)),'rs',4);
    hold;
    plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
    subplot(1,2,2);
    handle = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
    
    
    
    drawnow;
    
    delete(handle)
    
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
        marker = rotateMarker(marker, rotation);
        continuousRotation = continuousRotation + 1;
        
        if continuousRotation > 3    
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
    
    mapCrop = cropMap(map, pos(1), pos(2), rotation);
    
end

fprintf('%s: Invalid steps: %i; Valid steps: %i; Apples picked: %i\n'...
    ,npcName, invalidStep, validStep, picked);

end