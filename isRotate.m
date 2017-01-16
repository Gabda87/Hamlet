function [result] = isRotate(step)

%5: turnBack
%6: turnRight
%7: turnLeft

	rotateSteps = step(5:7);
	result = min(1, sum(rotateSteps));

end