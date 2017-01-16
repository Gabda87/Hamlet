function [step] = nextStep(nnParams, mapCrop, ...
            patternNumber, hiddenLayerSize_2, commandSize)
    

    n = size(mapCrop,1); %the mapCrop in n * n * k
    k = size(mapCrop,3); %k = features
    %k is the number of items we want the NN to learn to handle
    l = patternNumber;
    hiddenLayerSize_1 = n * n * l + 1;

    X = reshape(mapCrop, [], k);

    % X n*n x k
    % P k * l

    P      = reshape(nnParams(1:(k * l)), k, l);
    Theta1 = reshape(nnParams((k * l + 1):(k * l + hiddenLayerSize_1 * hiddenLayerSize_2)), hiddenLayerSize_1, hiddenLayerSize_2);
    Theta2 = reshape(nnParams((k * l + hiddenLayerSize_1 * hiddenLayerSize_2 + 1):end), (hiddenLayerSize_2 + 1), commandSize);


    A1 = X * P;
    A1 = [1 A1(:)'];

    A2 = [1 sigmoid(A1 * Theta1)];

    A3 = sigmoid(A2 * Theta2);
    step = predict(A3); % zeros and one 1, only keep the highest value
    
end