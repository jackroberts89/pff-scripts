close all;
%%
%    '/home/jack/PhaseFeedforward/CTFData/201412/'
dataSetNames = {
    '20141210_2035_R56_+0.3_Gate_375_435_GainK1_0_GainK2_0',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_0_K2_0',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_0_K2_2',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_0_K2_4',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_0_K2_6',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_0_K2_8',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_0_K2_10',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_2_K2_0',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_4_K2_0',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_6_K2_0',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_8_K2_0',...
    '20141210_2100_Gate_375_435_Const_K1_+800_K2_-800_Delay_K1_10_K2_0'...
};

k2Delay = [0 0 2 4 6 8 10 -2 -4 -6 -8 -10];
sortedDelay = sort(k2Delay(2:end));

dataSetLabels = {
    'Delay K1=0 K2=0',...
    'Delay K1=0 K2=2',...
    'Delay K1=0 K2=4',...
    'Delay K1=0 K2=6',...
    'Delay K1=0 K2=8',...
    'Delay K1=0 K2=10',...
    'Delay K1=2 K2=0',...
    'Delay K1=4 K2=0',...
    'Delay K1=6 K2=0',...
    'Delay K1=8 K2=0',...
    'Delay K1=10 K2=0'...
};

bpmsToPlot = { % changes to script means this doesn't work with more than one BPM any more!
%     'CC.SVBPM0235H',...
%     'CC.SVBPM0275H',...
%     'CC.SVBPM0365H',...
%     'CC.SVBPM0435H',...
%     'CC.SVBPI0535H',...
%     'CC.SVBPI0645H',...
%     'CC.SVBPI0685H',...
%     'CC.SVBPI0735H',...
%     'CC.SVBPM0845H',...
    'CC.SVBPM0930H'...
%     'CB.SVBPM0150H',...
%     'CB.SVBPS0210H',...
%     'CB.SVBPS0250H',...
%     'CB.SVBPS0310H',...
%     'CB.SVBPS0350H',...
%     'CB.SVBPS0410H',...
%     'CB.SVBPS0450H',...
%     'CB.SVBPS0510H',...
%     'CB.SVBPS0550H',...
%     'CB.SVBPS0610H',...
%     'CB.SVBPS0650H',...
%     'CB.SVBPS0710H',...
%     'CB.SVBPS0750H',...
%     'CB.SVBPS0810H',...
%     'CB.SVBPS0850H',...
%     'CB.SVBPS0910H',...
%     'CB.SVBPS0950H',...
%     'CB.SVBPM1030H'...
};

dataSetLabels = {
    'No Kick',...
    'Delay K1=0 K2=0',...
    'Delay K1=0 K2=2',...
    'Delay K1=0 K2=4',...
    'Delay K1=0 K2=6',...
    'Delay K1=0 K2=8',...
    'Delay K1=0 K2=10',...
    'Delay K1=2 K2=0',...
    'Delay K1=4 K2=0',...
    'Delay K1=6 K2=0',...
    'Delay K1=8 K2=0',...
    'Delay K1=10 K2=0'...
};

dataSetColours = [...
    1, 1, 1;...
    0, 0, 0;...
    0, 0, 1;...
    1, 0, 0;...
    0, 0.5, 0;...
    0.5, 0, 0.9;...
    1, 0.6, 0;...  
    0, 0, 1;...
    1, 0, 0;...
    0, 0.5, 0;...
    0.5, 0, 0.9;...
    1, 0.6, 0];    
    
dataSetStyles = {...
    '.';...
    '-';...
    '-';...
    '-';...
    '-';...
    '-';...
    '-';...  
    '--';...
    '--';...
    '--';...
    '--';...
    '--'};    

dataSetWidths = [...
    1,...
    3,...
    2,...
    2,...
    2,...
    2,...
    2,...
    2,...
    2,...
    2,...
    2,...
    2];


baseDir = '/home/jack/PhaseFeedforward/CTFData/';
processedDir = 'processed/';
saveDir = '/home/jack/PhaseFeedforward/Analysis/2014/RelativeKicks';
%%

nDataSets = length(dataSetNames);
processedData = cell(1,nDataSets);

nBPMsToPlot = length(bpmsToPlot);

for i=1:nDataSets
    yearMonth = dataSetNames{i}(1:6);
    dataPath = [baseDir yearMonth '/' dataSetNames{i} '/' processedDir dataSetNames{i} '.mat'];
    tmpData = load(dataPath);
    processedData{i} = tmpData.processedData;
end

%%

slope1Samps = 425:447;
slope2Samps = 458:477;

myColours = varycolor(nDataSets-1);

for b=1%1:nBPMsToPlot
    [noKick,~,noKick_err] = nanMeanStdErr(eval(['processedData{1}.bpmData.' bpmsToPlot{b} '.Samples.samples']));

    figure;
    for i=1:nDataSets
        [toPlot,toPlot_err] = nanMeanStdErr(eval(['processedData{i}.bpmData.' bpmsToPlot{b} '.Samples.samples']));
        toPlot = toPlot - noKick;
        %toPlot_err = sqrt(toPlot_err.^2 + noKick_err.^2);
        
        [maxSlope1,maxSlope1Ind] = max(toPlot(slope1Samps));
        maxSlope1_err = toPlot_err(maxSlope1Ind+slope1Samps(1)-1);
        [minSlope1,minSlope1Ind] = min(toPlot(slope1Samps));
        minSlope1_err = toPlot_err(minSlope1Ind+slope1Samps(1)-1);
        [maxSlope2,maxSlope2Ind] = max(toPlot(slope2Samps));
        maxSlope2_err = toPlot_err(maxSlope2Ind+slope2Samps(1)-1);
        [minSlope2,minSlope2Ind] = min(toPlot(slope2Samps));
        minSlope2_err = toPlot_err(minSlope2Ind+slope2Samps(1)-1);
        
        slope1Diff(i) = maxSlope1-minSlope1;
        slope1Diff_err(i) = sqrt(maxSlope1_err^2 + minSlope1_err^2)./sqrt(length(slope1Samps));
        slope2Diff(i) = maxSlope2-minSlope2;
        slope2Diff_err(i) = sqrt(maxSlope2_err^2 + minSlope2_err^2)./sqrt(length(slope2Samps));
        if (i>1)
            plot(toPlot,'Color',myColours(k2Delay(i)==sortedDelay,:),'LineWidth',2)
            hold all;
        end
    end
%     legend(dataSetLabels{1:nDataSets});
%     title(bpmsToPlot{b});
    title('BPM Position with Varying K2 Offset')
    set(gcf, 'Colormap', myColours);
    figColBar = colorbar;
    allTicks = linspace(0,1,nDataSets);
    set(figColBar,'YTick',allTicks(2:nDataSets));
    set(figColBar,'YTickLabel',sortedDelay);
    ylabel(figColBar,'K2 Delay [clock cycles]');
    xlim([410 490])
    format_plots;
    xlabel('Sample No.')
    ylabel('Position [mm]')
    %savePlot(saveDir,'bpmTraces');
end

[meanSlopeDiff,~,meanSlopeDiff_err] = nanMeanStdErr([slope1Diff; slope2Diff]);

figure;
errorbar(k2Delay(2:end),slope1Diff(2:end),slope1Diff_err(2:end),'o');
hold all;
errorbar(k2Delay(2:end),slope2Diff(2:end),slope2Diff_err(2:end),'o');
% plot(k2Delay(2:end),meanSlopeDiff(2:end),'o');

figure;
[a1,b1,c1]=nanpolyfit(k2Delay(3:7),slope1Diff(3:7),1,slope1Diff_err(3:7));
[a2,b2,c2]=nanpolyfit(k2Delay(8:end),slope1Diff(8:end),1,slope1Diff_err(8:end));
a1_err = (a1-c1(1,:))/2;
a2_err = (a2-c1(1,:))/2;
offDiff = a2(2)-a1(2);
gradDiff = a1(1)-a2(1);
gradDiff_err = sqrt(a1_err(1)^2 + a2_err(1)^2);
offDiff_err = sqrt(a1_err(2)^2 + a2_err(2)^2);
bestDelay = offDiff/gradDiff;
bestDelay_err = bestDelay*sqrt( (offDiff_err/offDiff)^2 + (gradDiff_err/gradDiff)^2 );
s1=errorbar(k2Delay(2:end),slope1Diff(2:end),slope1Diff_err(2:end),'bo','MarkerFaceColor','b');
hold all;
plot(-15:15,polyval(a1,-15:15),'b','LineWidth',2);
plot(-15:15,polyval(a2,-15:15),'b','LineWidth',2);
xlim([-12 12])
ylim([0 2.5])
plot([bestDelay bestDelay],[0 2.5],'b--','LineWidth',1)
[a1,b1,c1]=nanpolyfit(k2Delay(3:7),slope2Diff(3:7),1,slope2Diff_err(3:7));
[a2,b2,c2]=nanpolyfit(k2Delay(8:end),slope2Diff(8:end),1,slope2Diff_err(8:end));
a1_err = (a1-c1(1,:))/2;
a2_err = (a2-c1(1,:))/2;
offDiff = a2(2)-a1(2);
gradDiff = a1(1)-a2(1);
gradDiff_err = sqrt(a1_err(1)^2 + a2_err(1)^2);
offDiff_err = sqrt(a1_err(2)^2 + a2_err(2)^2);
bestDelay = offDiff/gradDiff;
bestDelay_err = bestDelay*sqrt( (offDiff_err/offDiff)^2 + (gradDiff_err/gradDiff)^2 );
s2=errorbar(k2Delay(2:end),slope2Diff(2:end),slope2Diff_err(2:end),'ro','MarkerFaceColor','r');
hold all;
plot(-15:15,polyval(a1,-15:15),'r','LineWidth',2);
plot(-15:15,polyval(a2,-15:15),'r','LineWidth',2);
plot([bestDelay bestDelay],[0 2.5],'r--','LineWidth',1)
xlabel('K2 Delay [clock cycles]')
ylabel('Peak Beam Offset [mm]')
title('Beam Offset vs. Output Delay')
legend([s1,s2],'Rising Edge','Falling Edge')
format_plots
%savePlot('saveDir','bothFits')

% savePlot(saveDir,'firstSlopeFit');