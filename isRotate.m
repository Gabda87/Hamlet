function [result] = isRotate(step)

	rotateSteps = step(5:7);
	result = min(1, sum(rotateSteps));

end