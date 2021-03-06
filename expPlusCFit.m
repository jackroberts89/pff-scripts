function [fitresult, gof] = expPlusCFit(x, y, weights)
%createExpPlusCFit(x,y,weights)
%  Makes a y = a*exp(-x/b) + c fit.
%
%  Data for fit:
%      X Input : x
%      Y Output: y
%      Weights : weights
%      Starting values for fit parameters: startParams
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 03-Jun-2013 15:34:02

%% INITIAL VALUES FOR INPUT PARAMETERS
% a = amplitude, estimate as amplitude at x=0 - amplitude at end?
% c = min amplitude (amplitude at end pulse???)
% b = -x / ln( (y-c)/a ) (use value of x,y near middle of pulse?)

initC = y(length(y));
initA = y(1) - initC;
initB = NaN*ones(1,length(y));
for i=1:length(y)
    initB(i) = -x(i) ./ log( (y(i)-initC)./initA); 
end
initB = real(initB);
infSamples = initB == inf;
initB = initB(~infSamples);
infSamples = initB == -inf;
initB = initB(~infSamples);
initB = nanmean(initB);
startParams = [initA initB initC];

%% Fit: 'untitled fit 1'.
[xData, yData, weights1] = prepareCurveData( x, y, weights );

% Set up fittype and options.
ft = fittype( 'a*exp(-x/b)+c', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf];
opts.StartPoint = startParams;
opts.Upper = [Inf Inf Inf];
opts.Weights = weights1;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'y vs. x with weights', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel( 'x' );
% ylabel( 'y' );
% grid on


