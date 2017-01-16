%function fullTrain(number)

clear; clc;
number = 1000;
mutationStepSize = 0.1;

%Creating NNs
cropHalfSize = 5;
cropSize = cropHalfSize * 2 + 1;
features = 2;
commandSize = 8;
hiddenLayerSize_2 = commandSize * floor(sqrt(sqrt(cropSize * cropSize * features / commandSize)));
patternNumber = 2;
hiddenLayerSize_1 = cropSize * cropSize * patternNumber;

load('map1.mat','map');

epsilon = zeros(3,1);
epsilon(1) = sqrt( 6 / (features + patternNumber));
epsilon(2) = sqrt( 6 / (hiddenLayerSize_1 + 1 + hiddenLayerSize_2));
epsilon(3) = sqrt( 6 / (hiddenLayerSize_2 + 1 + commandSize));

paramSizes(1) = features * patternNumber;
paramSizes(2) = (hiddenLayerSize_1 + 1) * hiddenLayerSize_2;
paramSizes(3) = (hiddenLayerSize_2 + 1) * commandSize;

nnParamsAll = zeros(number, sum(paramSizes));

for i=1:number
    
    P      = rand(features, patternNumber) * 2 * epsilon(1) -  epsilon(1);
    Theta1 = rand(hiddenLayerSize_1 + 1, hiddenLayerSize_2) * 2 * epsilon(2) -  epsilon(2);
    Theta2 = rand(hiddenLayerSize_2 + 1, commandSize) * 2 * epsilon(3) -  epsilon(3);
    
    nnParams = [P(:); Theta1(:); Theta2(:)];
    
    while fastEvaluate(map, nnParams, patternNumber, hiddenLayerSize_2, commandSize, cropSize) < 5
        
        P      = rand(features, patternNumber) * 2 * epsilon(1) -  epsilon(1);
        Theta1 = rand(hiddenLayerSize_1 + 1, hiddenLayerSize_2) * 2 * epsilon(2) -  epsilon(2);
        Theta2 = rand(hiddenLayerSize_2 + 1, commandSize) * 2 * epsilon(3) -  epsilon(3);
        
        nnParams = [P(:); Theta1(:); Theta2(:)];
        
    end
    
    nnParamsAll(i, :) = nnParams(:);
    
end

fprintf('NPCs created %i.\n', commandSize);
myVars = {'nnParamsAll', 'features', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
save(strcat('NPCs\','bunch1','.mat'), myVars{:});

%end

