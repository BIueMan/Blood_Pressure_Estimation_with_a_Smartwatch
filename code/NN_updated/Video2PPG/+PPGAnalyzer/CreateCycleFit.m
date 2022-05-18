function [fitresult, gof, coeffs] = CreateCycleFit(cycle, samplingRate, draw)
%CreateCycleFit
%  Creates a gaussian3 fit for the cycle
%
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%      coeffs : matrix of coeffs from the fit (sorted by x0). each column
%               is for one gaussian

    %% Init params
    import PPGAnalyzer.*
    
    if nargin < 3
        draw = (nargout == 0);
    end
    
    X = (1:length(cycle)) ./ samplingRate;
    
    %% Find Peaks
    indexesOfDominantPeaks = [Inf, Inf, Inf];
    [ pks, locs, ~, ~ ] = GetDominantPeaks( cycle, 'n', 3);
    indexesOfDominantPeaks(1:length(locs)) = locs;
    
    %% Difine Upper and Lower Bounds
    offset = 0.2;
    timeOfDominantPeaks = indexesOfDominantPeaks ./ samplingRate;
    
    lowerBounds = timeOfDominantPeaks .* (1 - offset);
    lowerBounds(lowerBounds == Inf) = 0;
    upperBounds = timeOfDominantPeaks .* (1 + offset);
    upperBounds(upperBounds == Inf) = X(end);
    
    %%    
    [xData, yData] = prepareCurveData( X(:), cycle(:) );

    % Set up fittype and options.
    ft = fittype( 'gauss3' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    
    opts.Lower = zeros(1, 9);
    opts.Lower([2, 5, 8]) = lowerBounds;
    
    opts.Upper = repmat([max(cycle), length(cycle), Inf], 1, 3);
    opts.Upper([2, 5, 8]) = upperBounds;

    % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );

    %% Get coeffs
    coeffs = reshape(coeffvalues(fitresult), 3, 3);
    [~, I] = sort(coeffs(2, :));
    coeffs = coeffs(:, I);
    
    %% Plot fit with data
    if draw
        h = plot( fitresult, xData, yData);
        h(2).LineWidth = 2;
        hold on;
        
        %plot(locs ./ samplingRate, pks, 'o', 'Color', 'g', 'LineWidth', 2);
        
        for jj = 1:3
            %y = gaussmf(xData, coeffs([3 2], jj)) .* coeffs(1, jj);
            %plot(xData, y);
        end
        
        xs = [fitresult.b1 fitresult.b2 fitresult.b3];
        %ys = feval(fitresult, xs);
        %plot(xs, ys, 'o', 'Color', 'g', 'LineWidth', 2);
        yL = get(gca,'YLim');
        for i=1:length(xs)
            line([xs(i) xs(i)], yL, 'Color', 'black', 'LineWidth', 2);
        end
        
        legend(h, 'Raw Cycle', 'Gaussian Fit', 'Location', 'NorthEast' );
        ylabel('');
        xlabel('\Delta Time [sec]')
        grid on
        
        hold off;
        ylim(yL);
        disp(gof);
    end

end

