function [pred] = predict(vector)

	pred = vector .* 0; %sets the size
    
    %vector(3:4)=0; %disabling moves other than forward
    %as it can stuck in a backward-forward loop
    
	[~, I] = max(vector);
    
	pred(I) = 1;
    
end
