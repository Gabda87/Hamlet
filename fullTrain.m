%function fullTrain(number)
clear; clc,
number = 100;
mutationStepSize = 0.1;

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


values = zeros(number,4);
%1: score
%2: number
%3: fitness
%4: variation

chP = zeros(size(P));
chTheta1 = zeros(size(Theta1));
chTheta2 = zeros(size(Theta2));


while (notIncreased < 20)
    
    cycle = cycle + 1;
    
    
    for i=1:number
        values(i, 1) = fastEvaluate(map, nnParamsAll(i, :), patternNumber, hiddenLayerSize_2, commandSize);
        values(i, 2) = i;
        values(i, 3) = values(i, 1);
    end
    
    [maxPicked, maxPicker] = max(values(:, 1));
    
    sorted=sortrows(values);
    
    newnnParamsAll = zeros(size(nnParamsAll));
    newnnParamsAll(1, :) = nnParamsAll(sorted(number,2), :);
    %the best one goes direcly to the next generation
    
    for i=1:number
        values(i, 4) = sum((nnParamsAll(i, :)-newnnParamsAll(1, :)).^2);
    end
    
    [maxDistance, mostDifferent] = max(values(:, 4));
    
    for i=1:number
        values(i, 1) = (1 - values(i, 3)/maxPicked)^2 + (1 - values(i, 4)/maxDistance)^2;
    end
    
    values(maxPicker ,1) = 0;
    
    %the smaller the score, the better
    sorted=sortrows(values);
    
    for i=2:number
        
        p1 = 1;
        while( p1 < number && rand() > 10/number)
            p1 = p1 + 1;
        end
        
        p2 = 1;
        while( p2 < number && rand() > 10/number)
            p2 = p2 + 1;
        end
        
        p1Params = nnParamsAll(sorted(p1, 2), :);
        p2Params = nnParamsAll(sorted(p2, 2), :);
        
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
        
        newnnParamsAll(i, :) = [chP(:); chTheta1(:); chTheta2(:)];
        
        %mutation
        offset = 0;
        
        for j=1:3
            for k = 1:paramSizes(j)
                mutatedParam = 2 * epsilon(j) -  epsilon(j);
                if rand() < 0.01
                    nnParamsAll(i, k + offset) = nnParamsAll(i, k + offset) + ...
                        2 * (rand() - 0.5) * mutatedParam * mutationStepSize;
                end
            end
            offset = offset + paramSizes(j);
        end
    end
    
    nnParamsAll = newnnParamsAll;
    
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

