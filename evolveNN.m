function maxPicked = evolveNN(number, mapName)

if nargin < 2
    number = 100;
end

if nargin < 2
    mapName = 'map1.mat';
end

values = zeros(number,2);

for i=1:number
    values(i,1)=evaluateNN(strcat('NPC',int2str(i)), mapName);
    values(i,2)=i;
end

maxPicked = max(values(:, 1));

sorted=sortrows(values);

newNPCs = 0;

fifthPart = fix(number/5);

for i=1:number
    
    if values(i)<=sorted(fix(number * 0.8))
        
        newNPCs = newNPCs + 1;
        
        switch fix(newNPCs/fifthPart)
            case 0
                mutateNN(strcat('NPC',int2str(sorted((number-mod(i,fifthPart)),2))),...
                    strcat('NPC',int2str(i)), 0.01)
            case 1
                mutateNN(strcat('NPC',int2str(sorted((number-mod(i,fifthPart)),2))),...
                    strcat('NPC',int2str(i)), 0.05)
            case 2
                mutateNN(strcat('NPC',int2str(sorted((number-mod(i,fifthPart)),2))),...
                    strcat('NPC',int2str(i)), 0.10)
            otherwise
                mutateNN(strcat('NPC',int2str(sorted((number-mod(i,fifthPart)),2))),...
                    strcat('NPC',int2str(i)), 0.20)
        end
    end
    
end

end

