function evaluateAll( number, mapName )

if nargin < 2
  mapName = 'map1.mat';
end

values = zeros(number,1);

for i=1:number
    values(i,1)=evaluateNN(strcat('NPC',int2str(i)), mapName);
end

[M, I] = max(values);
fprintf('NPC%i has picked %i apples!\n',I, M);
fprintf('The average is %i.\n', fix(mean(values)));

end

