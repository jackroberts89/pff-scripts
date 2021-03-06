function [fitresult, gof] = sinFit(x, y, initParams)
%SINFIT(X,Y)
%  Create a sine fit: Asin(bx+c)
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 09-Apr-2014 10:41:09


%% Fit: 'untitled fit 1'.
%[xData, yData] = prepareCurveData( x, y );
xData = squeeze(x);
yData = squeeze(y);

% Set up fittype and options.
ft = fittype( 'sin1' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf 0 -Inf];
%opts.StartPoint = [11.6808159976615 0.0174532925199433 0.488941358647904]; % 0.0174532925199433
opts.StartPoint = initParams;
opts.Upper = [Inf Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
%figure( 'Name', 'untitled fit 1' );
%h = plot( fitresult, xData, yData );
%legend( h, 'y vs. x', 'untitled fit 1', 'Location', 'NorthEast' );
% Label axes
%xlabel( 'x' );
%ylabel( 'y' );
%grid on


