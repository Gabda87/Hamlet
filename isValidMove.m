function [result] = isValidMove(step, mapCrop)

	n = size(mapCrop, 1);
	mid = [(n + 1) / 2; (n + 1) / 2];
	direction = moveDirection(step, 0);
    %the mapCrop is rotated, there is no need for further rotation
	pos = mid + direction;
	result = isPassableTile(mapCrop(pos(1), pos(2), :));

end