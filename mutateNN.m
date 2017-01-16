function mutateNN(originalNPC, newNPC, mutationProbability)

myVars = {'nnParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
load(strcat('NPCs\',originalNPC,'.mat'), myVars{:});

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


P      = randomTheta(features, patternNumber);
Theta1 = randomTheta(cropSize * cropSize * patternNumber + 1, hiddenLayerSize_2);
Theta2 = randomTheta(hiddenLayerSize_2 + 1, commandSize);

mutatedParams = [P(:); Theta1(:); Theta2(:)];

for i=1:size(mutatedParams,1)
    if rand()<mutationProbability
        nnParams(i) = nnParams(i) + mutatedParams(i) * mutationProbability * sign(rand()-0.5);
    end
end

save(strcat('NPCs\',newNPC,'.mat'), myVars{:});

end