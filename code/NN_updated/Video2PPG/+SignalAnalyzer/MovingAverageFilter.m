function [ y ] = MovingAverageFilter( N, x )
    b = (1/N).*ones(1,N);
    a = 1;
    y = filter(b, a, x);
end

