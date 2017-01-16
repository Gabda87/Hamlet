function [result] = saveMap(map)

fileID = fopen('applegarden.map','w');
for i = 1:size(map, 1)
    for j = 1:size(map, 2)
        fprintf(fileID,'%i',map(j,i,2)*2+map(j,i,1));
    end
    fprintf(fileID,'\n');
end
fclose(fileID);

result = 1;

end

