function [func2] = integration(func)

    func2 = zeros(1,length(func));
    for i=2:length(func)
       func2(i) = (func(i-1) + func(i))/2;
    end
end