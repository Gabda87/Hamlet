function createNN(npcName)

cropHalfSize = 3;
cropSize = cropHalfSize * 2 + 1;
features = 2;
%1:
%2: trees
commandSize = 7;
hiddenLayerSize_2 = commandSize * floor(sqrt(sqrt(cropSize * cropSize * features / commandSize)));
patternNumber = 2;
%ideas for the possible patterns:
%value
%passable tarrain

load('map0.mat','map');

for i=1:1000
    P      = randomTheta(features, patternNumber);
    Theta1 = randomTheta(cropSize * cropSize * patternNumber + 1, hiddenLayerSize_2);
    Theta2 = randomTheta(hiddenLayerSize_2 + 1, commandSize);
    
    nnParams = [P(:); Theta1(:); Theta2(:)];
    
    if fastEvaluate(map, nnParams, patternNumber, hiddenLayerSize_2, commandSize) > 1
        %disp(i);
        break;
    end
    
end

myVars = {'nnParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
save(strcat('NPCs\',npcName,'.mat'), myVars{:});

end