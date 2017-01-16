function [result] = isPassableTile(tile)

    tile = tile(:);
	result = not(tile(2)); %can add more with &

end

