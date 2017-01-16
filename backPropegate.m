function [newnnParams] = backPropegate(nnParams, mapCrop, alpha, ...
            lambda, patternNumber, hiddenLayerSize_2, commandSize)
    

    n = size(mapCrop,1); %the mapCrop is n * n * k
    k = size(mapCrop,3);
    %k is the number of items we want the NN to learn to handle
    l = patternNumber;
    hiddenLayerSize_1 = n * n * l + 1;
    stepNum=0;

    X = reshape(mapCrop, [], k);

    % X n*n x k
    % P k * l

    P      = reshape(nnParams(1:(k * l)), k, l);
    Theta1 = reshape(nnParams((k * l + 1):(k * l + hiddenLayerSize_1 * hiddenLayerSize_2)), hiddenLayerSize_1, hiddenLayerSize_2);
    Theta2 = reshape(nnParams((k * l + hiddenLayerSize_1 * hiddenLayerSize_2 + 1):end), (hiddenLayerSize_2 + 1), commandSize);

    Theta2_grad = zeros(size(Theta2));
    Theta1_grad = zeros(size(Theta1));
    P_grad = zeros(size(P));
    
    %Back propagation for some intuitive cases
    %1: trying to go onto an impassable terrain
    %2: rotating twice in a row, as every rotation can be done in 1 step
    moved = 0;
    %we want it to learn until it makes a move
    %learning not to rotate indefinitly and not hitting walls
    
    %it can end in a move in the 1st stpe
    %or a rotation and a step after
    %or it tried for too long
    while (not(moved) && (stepNum < 200))
                
        stepNum = stepNum + 1;

        A1 = X * P;
        A1 = [1 A1(:)'];

        A2 = [1 sigmoid(A1 * Theta1)];

        A3 = sigmoid(A2 * Theta2);
        
        step = predict(A3); % zeros and one 1

        [M, I] = max(step);
        %fprintf('%i', I);
        
        Theta1_Reg = Theta1;
        Theta1_Reg(1, :) = 0;

        Theta2_Reg = Theta2;
        Theta2_Reg(1, :) = 0;

        %we only correct for the previus rotation, and leave the last one
        if isRotate(step) %penalty for rotating twice in a row
            
            mapCrop = rotateMap(mapCrop, step);
            
            Theta2 = Theta2 - alpha * Theta2_grad;
            Theta1 = Theta1 - alpha * Theta1_grad;
            P      = P      - alpha *      P_grad;

            %Y = 1 - step;
            delta_3 = A3 .* step;

            delta_2 = delta_3 * Theta2';
            delta_2 = delta_2(2:end);
            delta_2 = delta_2 .* sigmoidGradient(A1 * Theta1);

            delta_1 = delta_2 * Theta1';
            delta_1r = reshape(delta_1(2:end), n * n, l);

            Theta2_grad = A2' * delta_3 + lambda * Theta2_Reg;
            Theta1_grad = A1' * delta_2 + lambda * Theta1_Reg;
            P_grad = 1 / (n * n) * X' * delta_1r + lambda / (n * n) * P;
            %There are no "ones" at the beggining of P

        end

        if isMove(step)
            if isValidMove(step,mapCrop)
                moved = 1;
                delta_3 = step .* 0;
            else %penalty for going into a wall
                
                %Y = 1 - step;
                %delta_3 = A3 - Y;
                delta_3 = A3 .* step;

                delta_2 = delta_3 * Theta2';
                delta_2 = delta_2(2:end);
                delta_2 = delta_2 .* sigmoidGradient(A1 * Theta1);

                delta_1 = delta_2 * Theta1';
                delta_1r = reshape(delta_1(2:end), n * n, l);

                Theta2_grad = A2' * delta_3 + lambda * Theta2_Reg;
                Theta1_grad = A1' * delta_2 + lambda * Theta1_Reg;
                P_grad = 1 / (n * n) * X' * delta_1r + lambda / (n * n) * P;
                %There are no "ones" at the beggining of P

                Theta2 = Theta2 - alpha * Theta2_grad;
                Theta1 = Theta1 - alpha * Theta1_grad;
                P      = P      - alpha *      P_grad;

                Theta2_grad = zeros(size(Theta2));
                Theta1_grad = zeros(size(Theta1));
                P_grad = zeros(size(P));

            end
            
            disp(A3);
            disp(delta_3);
        end

    end
    
    newnnParams = [P(:); Theta1(:); Theta2(:)];
    
    %fprintf('\n%i steps taken. \n\n',stepNum);
    %[M, I] = max(step);
    %fprintf('The last step was %i.\n\n',I);
    
end