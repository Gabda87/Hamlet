%function fullTrain(number)
clear; clc,
number = 100;

%Creating NNs
cropHalfSize = 3;
cropSize = cropHalfSize * 2 + 1;
features = 2;
commandSize = 7;
hiddenLayerSize_2 = commandSize * floor(sqrt(sqrt(cropSize * cropSize * features / commandSize)));
patternNumber = 2;
hiddenLayerSize_1 = cropSize * cropSize * patternNumber;

load('map0.mat','map');

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
    
    while fastEvaluate(map, nnParams, patternNumber, hiddenLayerSize_2, commandSize) < 5
        
        P      = rand(features, patternNumber) * 2 * epsilon(1) -  epsilon(1);
        Theta1 = rand(hiddenLayerSize_1 + 1, hiddenLayerSize_2) * 2 * epsilon(2) -  epsilon(2);
        Theta2 = rand(hiddenLayerSize_2 + 1, commandSize) * 2 * epsilon(3) -  epsilon(3);
        
        nnParams = [P(:); Theta1(:); Theta2(:)];
        
    end
    
    nnParamsAll(i, :) = nnParams(:);
    
end

fprintf('NPCs created.\n');

%Evolving NNs

notIncreased = 0;
previousMax = 0;
cycle = 0;


values = zeros(number,2);

while (notIncreased < 20)
    
    cycle = cycle + 1;
    
    
    for i=1:number
        values(i, 1) = fastEvaluate(map, nnParamsAll(i, :), patternNumber, hiddenLayerSize_2, commandSize);
        values(i, 2) = i;
    end
    
    [maxPicked, maxPicker] = max(values(:, 1));
    
    sorted=sortrows(values);
    
    newNPCs = 0;
    fifthPart = fix(number/5);
    
    for i=1:number
        
        if values(i)<=sorted(fix(number * 0.8))
            
            newNPCs = newNPCs + 1;
            
            switch fix(newNPCs/fifthPart)
                case 0
                    mutationProbability = 0.04;
                case 1
                    mutationProbability = 0.08;
                case 2
                    mutationProbability = 0.16;
                otherwise
                    mutationProbability = 0.32;
            end
            
            nnParamsAll(i, :) = nnParamsAll(sorted(number-mod(i, fifthPart), 2), :);
            offset = 0;
            
            for j=1:3
                for k = 1:paramSizes(j)
                    mutatedParam = 2 * epsilon(j) -  epsilon(j);
                    if rand()<mutationProbability
                        nnParamsAll(i, k + offset) = nnParamsAll(i, k + offset) + ...
                            rand() * mutatedParam * mutationProbability * sign(rand()-0.5);
                    end
                end
                offset = offset + paramSizes(j);
            end
        end
    end
    
    currentMax = maxPicked;
    
    if currentMax > previousMax
        notIncreased = 0;
        previousMax = currentMax;
        fprintf('%i: New record, NPC%i has picked %i apples.\n', cycle, maxPicker, currentMax);
        nnParams(:) = nnParamsAll(maxPicker, :);
        myVars = {'nnParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
        save(strcat('NPCs\','bunch1best','.mat'), myVars{:});
    else
        notIncreased = notIncreased + 1;
        %fprintf('%i: No development.\n', cycle);
        fprintf('.');
    end
end

fprintf('\n');
myVars = {'nnParamsAll', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
save(strcat('NPCs\','bunch1','.mat'), myVars{:});

%end

