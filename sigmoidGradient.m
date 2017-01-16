function g = sigmoidGradient(z)
%SIGMOIDGRADIENT returns the gradient of the sigmoid function
%evaluated at z

s = sigmoid(z);
g = s .* (1 - s);
end
