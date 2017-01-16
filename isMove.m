function  [result] = isMove(step)

	moveSteps = step(1:4);
	result = min(1, sum(moveSteps));

end