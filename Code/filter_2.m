function [zerovel] = filter_2(zerovel)    

    N = length(zerovel);

    for i=1+2:N-1
        if((zerovel(i-2) == zerovel(i+1))&&(zerovel(i) ~= zerovel(i+1)))
            zerovel(i) = zerovel(i+1);
            zerovel(i-2) = zerovel(i+1);
        end
    end
end