function fullTrain(number)

if nargin < 1
    number = 100;
end

for i=1:number
    createNN(strcat('NPC',int2str(i)));
end

fprintf('NPCs created.\n');

notIncreased = 0;
previousMax = 0;
cycle = 0;


while (notIncreased < 20)
   
    cycle = cycle + 1;
    
    currentMax = evolveNN(number, 'map0.mat');
    
    if currentMax > previousMax
        notIncreased = 0;
        previousMax = currentMax;
        fprintf('%i: New record, %i apples picked.\n', cycle, currentMax);
    else
        notIncreased = notIncreased + 1;
    end
    
end

