function  [result] = isMove(step)

%1: moveForward
%2: moveRight
%3: moveBackward
%4: moveLeft

	moveSteps = step(1:4);
	result = min(1, sum(moveSteps));

end