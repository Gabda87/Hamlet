%function [map] = createMap()

probability1 = 0.7;
probability2 = 0.95;
halfMapSize = 25;
features = 2;

map = randomMap(halfMapSize, features, probability1, probability2);
map(:, halfMapSize + 1, 1) = 0;
map(halfMapSize, :, 1) = 0;
map(halfMapSize+1, halfMapSize:halfMapSize+2, 1) = 0;
map = makeTreeBorder(map,5);

hold off;
subplot(1,2,1);
spy(sparse(map(:,:,1)),'rs',4);
hold;
plot(halfMapSize + 1, halfMapSize + 1, 'b^', 'MarkerSize', 5, 'MarkerFaceColor', 'b');

subplot(1,2,2);
spy(sparse(map(:,:,2)),'gs',4);
hold;
plot(halfMapSize + 1, halfMapSize + 1, 'b^', 'MarkerSize', 5, 'MarkerFaceColor', 'b');

%saveMap(map);
save('map1.mat','map');

%end

