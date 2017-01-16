function teachNN(npcName, mapName, loops)

load(mapName,'map');
halfMapSize = (size(map, 1) - 1) / 2;

myVars = {'nnParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
load(npcName, myVars{:});


pos=[halfMapSize + 1; halfMapSize + 1];
%it is the middle of the map
rotation = 0;
%looking UP

mapCrop = cropMap(map, pos(1), pos(2), rotation);
%we rotate the map istead of the NPC
%the NPS is always looking UP in mapCrop

alpha = 0.01;
lambda = 0.1;
%learning rates

picked = 0;
%the number of apples
forwardStep = zeros(commandSize, 1);
forwardStep(1) = 1;

for i = 1:loops
   
    nextTile = pos + moveDirection(forwardStep, rotation);
    
    if map(nextTile(1), nextTile(2), 1) == 1
        
        %we pick the apple if it is in front of us
        map(nextTile(1), nextTile(2), 1) = 0;
        picked = picked + 1;

    end
    
    step = zeros(commandSize, 1);

    old = nnParams.^2;
    
    while(not(isValidStep(step, mapCrop)))

        nnParams = backPropegate(nnParams, mapCrop, alpha, lambda, patternNumber, hiddenLayerSize_2, commandSize);
        %if the 1st or the 2nd step is a movement, 
        %it doesn't change the parameters

        step = nextStep(nnParams, mapCrop, patternNumber, hiddenLayerSize_2, commandSize);
        %decides the next step (nothing random so far)
        
    end
    
    new = nnParams.^2;
    fprintf('Difference: %f\n', sum(old)-sum(new));
    
    if isRotate(step)

        rotation = rotateRotation(rotation, step);

    end

    if isMove(step)

        pos = pos + moveDirection(step, rotation);

    end

    mapCrop = cropMap(map, pos(1), pos(2), rotation);
   
end

save(npcName, myVars{:});

fprintf('Done. %i apples picked.\n',picked);
end