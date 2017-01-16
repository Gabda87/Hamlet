hold off; clear ; clc

load('map1.mat');
halfMapSize = (size(map, 1) - 1) / 2;
%map = makeTreeBorder(map,3);
load('NPC1.mat');
%'nnParams', 'patternNumber', 'hiddenLayerSize_2','commandSize', 'cropSize'

%saveMap(map);

features = size(map, 3);
%1:
%2: trees

pos=[halfMapSize + 1; halfMapSize + 1];
%it is the middle of the map
rotation = 0;
%looking UP
marker = 'b^';
marker = rotateMarker(marker, rotation);

% subplot(1,2,1);
% spy(sparse(map(:,:,2)),'gs',4);
% hold;
% subplot(1,2,2);
% spy(sparse(map(:,:,1)),'rs',4);
% hold;
% subplot(1,2,1);
% npcHandle = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
% subplot(1,2,2);
% npcHandleB = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
% drawnow;

mapCrop = cropMap(map, pos(1), pos(2), rotation);
%we rotate the map istead of the NPC
%the NPS is always looking UP in mapCrop

commandName = {'moveForward';'moveRight';'moveBackward';'moveLeft';...
    'turnBack';'turnRight';'turnLeft'};
commandCode = ['W'; 'D'; 'S'; 'A'; 'X'; 'E'; 'Q'];
%for the RPGMaker VX code

alpha = 0.01;
lambda = 0.0;
%learning rates

fileID = fopen('sim1.lst','w');

picked = 0;
%the number of apples
forwardStep = zeros(commandSize, 1);
forwardStep(1) = 1;



for i = 1:50
    %fprintf('Step %i:\n',i);
    nextTile = pos + moveDirection(forwardStep, rotation);
    if map(nextTile(1), nextTile(2), 1) == 1
        %we pick the apple if it is in front of us
        map(nextTile(1), nextTile(2), 1) = 0;
        picked = picked + 1;
        fprintf(fileID,' '); 
        
%         subplot(1,2,2);
%         hold off;
%         spy(sparse(map(:,:,1)),'rs',4);
%         hold;
    end
    
    step = zeros(commandSize, 1);

    while(not(isValidStep(step, mapCrop)))%TODO it is not rotated

        nnParams = backPropegate(nnParams, mapCrop, alpha, lambda, patternNumber, hiddenLayerSize_2, commandSize);
        %if the 1st or the 2nd step is a movement, 
        %it doesn't change the parameters

        step = nextStep(nnParams, mapCrop, patternNumber, hiddenLayerSize_2, commandSize);
        %decides the next step (nothing random so far)

        [M, I] = max(step);
        %fprintf('\nTrying step %i. Rotation: %i\n', I, rotation);
        fprintf('next\n');
    end


    [M, I] = max(step);
    fprintf(fileID,'%c',commandCode(I));
    
    %fprintf('\nThe step will be: %i; The rotation is: %i\n\n', I, rotation);
    %pause;
    
    if isRotate(step)

        rotation = rotateRotation(rotation, step);
        marker = rotateMarker(marker, rotation);

    end

    if isMove(step)

        pos = pos + moveDirection(step, rotation);

    end

    mapCrop = cropMap(map, pos(1), pos(2), rotation);

    
    
%     if ishandle(npcHandle)
%         delete(npcHandle);
%     end
%     
%     if ishandle(npcHandleB)
%        delete(npcHandleB);
%     end

%     subplot(1,2,1);
%     npcHandle = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');
%     subplot(1,2,2);
%     npcHandleB = plot(pos(2),pos(1),marker,'MarkerSize',5,'MarkerFaceColor','b');

%     drawnow limitrate;
    %drawnow;
    
end

fclose(fileID);

save('NPC1.mat', 'nnParams', 'patternNumber', 'hiddenLayerSize_2',...
    'commandSize', 'cropSize')

%result = nnParams;
fprintf('Done. %i apples picked.\n',picked);
%end