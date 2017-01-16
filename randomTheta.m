function [ Theta ] = randomTheta(inputSize, outputSize)

    epsilon = sqrt( 6 / (inputSize + outputSize));
    
    Theta = rand(inputSize, outputSize) * 2 * epsilon -  epsilon;
    
end

