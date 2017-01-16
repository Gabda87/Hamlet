hold off; clear ; clc
cropHalfSize = 3;
cropSize = cropHalfSize * 2 + 1;
features = 2;
%1:
%2: trees
probability = 0.85;
halfMapSize = 50;
pos=[halfMapSize + 1; halfMapSize + 1];
%it is the middle of the map
rotation = 0;
%looking UP

map = randomMap(halfMapSize, features, probability);
%generates a map with a size of
%(halfMapSize*2+1, halfMapSize*2+1, features)
map = makeTreeBorder(map,3);
%makes a border in map(:,:,2)
save('map1.mat', 'map');

mapCrop = cropMap(map, pos(1), pos(2), rotation);
%we rotate the map istead of the NPC
%the NPS is always looking UP in mapCrop

marker = 'b^';
marker = rotateMarker(marker, rotation);

subplot(1,2,1);
spy(sparse(map(:,:,2)),'gs',4);
hold;
npcHandle = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');

commandSize = 7;
commandName = {'moveForward';'moveRight';'moveBackward';'moveLeft';...
    'turnBack';'turnRight';'turnLeft'};
commandCode = ['W'; 'D'; 'S'; 'A'; 'X'; 'E'; 'Q'];
%for the RPGMaker VX code
hiddenLayerSize_2 = commandSize * floor(sqrt(sqrt(cropSize * cropSize * features / commandSize)));
%this size seemd appropriate, because... long story

alpha = 0.01;
lambda = 0.0;

patternNumber = 2;
%ideas for the possible patterns:
%value
%passable tarrain
P = randomTheta(features, patternNumber);
Theta1 = randomTheta(cropSize * cropSize * patternNumber + 1, hiddenLayerSize_2);
Theta2 = randomTheta(hiddenLayerSize_2 + 1, commandSize);

nnParams = [P(:); Theta1(:); Theta2(:)];

for i = 1:1000
    %fprintf('Step %i:\n',i);
    
    step = zeros(commandSize, 1);
    
    while(not(isValidStep(step, mapCrop)))%TODO it is not rotated
        
        nnParams = backPropegate(nnParams, mapCrop, alpha, lambda, patternNumber, hiddenLayerSize_2, commandSize);
        %if the 1st or the 2nd step is a movement,
        %it doesn't change the parameters
        
        step = nextStep(nnParams, mapCrop, patternNumber, hiddenLayerSize_2, commandSize);
        %decides the next step (nothing random so far)
        
        [M, I] = max(step);
        %fprintf('\nTrying step %i. Rotation: %i\n', I, rotation);
    end
    
    
    [M, I] = max(step);
    fprintf('\nThe step will be: %s; The rotation is: %i\n\n', commandName{I}, rotation);
    
    if isRotate(step)
        
        rotation = rotateRotation(rotation, step);
        marker = rotateMarker(marker, rotation);
        
    end
    
    if isMove(step)
        
        pos = pos + moveDirection(step, rotation);
        
    end
    
    mapCrop = cropMap(map, pos(1), pos(2), rotation);
    
    if ishandle(npcHandle)
        delete(npcHandle);
    end
    
    subplot(1,2,1);
    npcHandle = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
    subplot(1,2,2);
    hold off;
    spy(sparse(mapCrop(:,:,2)),'gs',20);
    hold;
    plot(cropHalfSize + 1,cropHalfSize + 1,'b^','MarkerSize',5,'MarkerFaceColor','b');
    
    drawnow;
    pause;
    
end

save('NPC2.mat', 'nnParams', 'patternNumber', 'hiddenLayerSize_2',...
    'commandSize', 'cropSize')

%result = nnParams;
fprintf('Done.\n');
%end