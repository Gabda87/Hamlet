%function fullTrain(number)

clear; clc;
bunchNumber = '2';
myVars = {'nnParamsAll', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
load(strcat('NPCs\','bunch',bunchNumber,'.mat'), myVars{:});
load('map1.mat','map');
number = 100;
mutationStepSize = 0.01;
successfulMutation = zeros(100, 100);
born = 0;
mutated = 0;

%Creating NNs
features = 2;
patternNumber = 2;
hiddenLayerSize_1 = cropSize * cropSize * patternNumber;
P      = zeros(features, patternNumber);
Theta1 = zeros(hiddenLayerSize_1 + 1, hiddenLayerSize_2);
Theta2 = zeros(hiddenLayerSize_2 + 1, commandSize);


epsilon = zeros(3,1);
epsilon(1) = sqrt( 6 / (features + patternNumber));
epsilon(2) = sqrt( 6 / (hiddenLayerSize_1 + 1 + hiddenLayerSize_2));
epsilon(3) = sqrt( 6 / (hiddenLayerSize_2 + 1 + commandSize));

paramSizes(1) = features * patternNumber;
paramSizes(2) = (hiddenLayerSize_1 + 1) * hiddenLayerSize_2;
paramSizes(3) = (hiddenLayerSize_2 + 1) * commandSize;



%Evolving NNs

notIncreased = 0;
cycle = 0;


values = zeros(number,3);
%1: picked
%2: variation

chP = zeros(size(P));
chTheta1 = zeros(size(Theta1));
chTheta2 = zeros(size(Theta2));

for i=1:number
    values(i, 1) = fastEvaluate(map, nnParamsAll(i, :), patternNumber, hiddenLayerSize_2, commandSize);
end

[maxPicked, maxPicker] = max(values(:, 1));
previousMax = maxPicked;
averagePicked = mean(values(:, 1));

fprintf('New record: NPC%i has picked %i apples (average: %i).\n', maxPicker, maxPicked, fix(averagePicked));


while (notIncreased < 10 * number)
    
    cycle = cycle + 1;
    notIncreased = notIncreased + 1;
    
    
    %new specimen1
    p1 = ceil(rand() * number);
    p2 = ceil(rand() * number);
    
    p1Params = nnParamsAll(p1, :);
    p2Params = nnParamsAll(p2, :);
    
    k = features;
    l = patternNumber;
    p1P      = reshape(p1Params(1:(k * l)), k, l);
    p1Theta1 = reshape(p1Params((k * l + 1):(k * l + (hiddenLayerSize_1 + 1) * hiddenLayerSize_2)), hiddenLayerSize_1 + 1, hiddenLayerSize_2);
    p1Theta2 = reshape(p1Params((k * l + (hiddenLayerSize_1 + 1)* hiddenLayerSize_2 + 1):end), (hiddenLayerSize_2 + 1), commandSize);
    
    p2P      = reshape(p2Params(1:(k * l)), k, l);
    p2Theta1 = reshape(p2Params((k * l + 1):(k * l + (hiddenLayerSize_1 + 1) * hiddenLayerSize_2)), hiddenLayerSize_1 + 1, hiddenLayerSize_2);
    p2Theta2 = reshape(p2Params((k * l + (hiddenLayerSize_1 + 1)* hiddenLayerSize_2 + 1):end), (hiddenLayerSize_2 + 1), commandSize);
    
    for j=1:size(P,2)
        if rand()>0.5
            chP(:, j) = p1P(:, j);
        else
            chP(:, j) = p2P(:, j);
        end
    end
    
    for j=1:size(Theta1,2)
        if rand()>0.5
            chTheta1(:, j) = p1Theta1(:, j);
        else
            chTheta1(:, j) = p2Theta1(:, j);
        end
    end
    
    for j=1:size(Theta2,2)
        if rand()>0.5
            chTheta2(:, j) = p1Theta2(:, j);
        else
            chTheta2(:, j) = p2Theta2(:, j);
        end
    end
    
    chParams = [chP(:); chTheta1(:); chTheta2(:)];
    
    %mutation
    offset = 0;
    
    for j=1:3
        for k = 1:paramSizes(j)
            mutatedParam = 2 * epsilon(j) -  epsilon(j);
            if rand() < 0.05
                chParams(k + offset) = chParams(k + offset) + ...
                    2 * (rand() - 0.5) * mutatedParam * mutationStepSize;
            end
        end
        offset = offset + paramSizes(j);
    end
    
    score = fastEvaluate(map, chParams, patternNumber, hiddenLayerSize_2, commandSize);
    
    if score > averagePicked
        
        for i = 1:number
            values(i, 2) = sum((nnParamsAll(i, :) - chParams(:)').^2);
        end
        [leastDistance, mostSimilar] = min(values(:, 2));
        
        if score > values(mostSimilar, 1)
            notIncreased = 0;
            values(mostSimilar, 1) = score;
            averagePicked = mean(values(:, 1));
            nnParamsAll(mostSimilar, :) = chParams(:);
            fprintf('%i (%i; %i) ', fix(averagePicked), p1, p2);
            born = born + 1;
            
            if score > previousMax
                previousMax = score;
                fprintf('\n%i: New record, NPC%i has picked %i apples (average: %i; parents:%i, %i).\n',...
                    cycle, mostSimilar, score, fix(averagePicked), p1, p2);
                fprintf('Total distance from population: %f.\n', sum(values(:,2)));
                myVars = {'chParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
                save(strcat('NPCs\','bunch1best','.mat'), myVars{:});
            end
        end
    end
    
    %new specimen2
    
    p0 = ceil(rand() * number);
    chParams = nnParamsAll(p0, :);
    
    offset = 0;
    
    if rand() < 0.5
        mutationProbability = ceil(25 * rand()) / 100;
        mutationStepSize2   = ceil(100 * rand()) / 100;
    else
        mutationProbability = ceil(100 * rand()) / 100;
        mutationStepSize2   = ceil(25 * rand()) / 100;
    end
    
    for j=1:3
        for k = 1:paramSizes(j)
            mutatedParam = 2 * epsilon(j) -  epsilon(j);
            if rand() < mutationProbability
                chParams(k + offset) = chParams(k + offset) + ...
                    2 * (rand() - 0.5) * mutatedParam * mutationStepSize2;
            end
        end
        offset = offset + paramSizes(j);
    end
    
    score = fastEvaluate(map, chParams, patternNumber, hiddenLayerSize_2, commandSize);
    
    
    if score > values(p0, 1)
        a = fix(mutationProbability * 100);
        b = fix(mutationStepSize2 * 100);
        notIncreased = 0;
        values(p0, 1) = score;
        averagePicked = mean(values(:, 1));
        nnParamsAll(p0, :) = chParams(:);
        fprintf('%i (%i; %i, %i) ',...
            fix(averagePicked), p0, a, b);
        successfulMutation(a, b) = successfulMutation(a, b) + 1;
        mutated = mutated + 1;
        
        if score > previousMax
            previousMax = score;
            fprintf('\n%i: New record, NPC%i has picked %i apples (average: %i; mutated: %i).\n',...
                cycle, p0, score, fix(averagePicked), p0);
            fprintf('Total distance from population: %f.\n', sum(values(:,2)));
            myVars = {'chParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
            save(strcat('NPCs\','bunch1best','.mat'), myVars{:});
        end
    end
    
end

fprintf('\n');
myVars = {'nnParamsAll', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'};
save(strcat('NPCs\','bunch',bunchNumber,'.mat'), myVars{:});

%end

