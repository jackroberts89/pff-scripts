% comment out dataDirectory and plots in quickPhase to use.
close all;
clear all;
%%

baseDir = '/home/jack/PhaseFeedforward/CTFData/';
homeDir = pwd;
addpath(homeDir);
cd(baseDir);

dataSets = {...
    '201412/20141205_1200_R56_+0.5',... %K1
    '201412/20141205_1200_R56_+0.4_TimingScans_FF_K1Gain_0_K2Gain_0_noGate',...
    '201412/20141205_1330_R56_+0.3',...
    '201412/20141205_1025_TimingScans_FF_K1Gain_0_K2Gain_0_end',...
    '201412/20141205_1101_TimingScans_FF_K1Gain_26_K2Gain_-30_noGate',...
    '201412/20141205_1109_TimingScans_FF_K1Gain_-26_K2Gain_30_noGate',...
    '201412/20141205_1125_R56_-0.2_TimingScans_FF_K1Gain_26_K2Gain_-30_noGate',... 
    '201412/20141205_1125_R56_-0.2_TimingScans_FF_K1Gain_-26_K2Gain_30_noGate',...
};

dataSetNames = {
    'R56 = +0.5',...
    'R56 = +0.4',...
    'R56 = +0.3',...
    'R56 = +0.2 (1025)',...
    'R56 = +0.2 (1101)',...
    'R56 = +0.2 (1109)',...
    'R56 = -0.2 (FF On Gain+)',...
    'R56 = -0.2 (FF On Gain-)',...
};

dataDescription = 'R56 Scan';

calFile = '201412/frascatiCalibrations/frascatiCalibrationConstants_20141205_0944';
useDiode = 1;

bprCTCal = 155.1915;
bprCRCal = -0.358388;

%%
rawNames = dataSetNames;

for i=1:length(dataSets)
  tmpName = regexp(dataSets{i},'/','split');
  if length(tmpName)>1 % found a '/', last element should give name without leading directory paths
      tmpName = tmpName{length(tmpName)};
  end
  tmpName = regexp(tmpName,'_','split');
  dataSetNames{i} = [tmpName{1} ' ' tmpName{2} ' ' dataSetNames{i}]
  
%   dataSets{i}(6:13)
%   dataSets{i}(15:18)
%   dataSetNames{i} =[dataSets{i}(6:13) ' ' dataSets{i}(15:18) ' ' dataSetNames{i}]
end	


calibrationConstants = loadFrascatiCalibrationConstants(calFile);


DataSetBaseTitle=[tmpName{1} ' ' tmpName{2}];
%DataSetBaseTitle=[dataSets{1}(6:13) ' ' dataSets{1}(15:18)];


nDataSets = length(dataSets);


bpmName = 'CC.SVBPM0930H.Samples.samples.value';
bpmSamples = cell(1,nDataSets);


allData = cell(1,nDataSets);
allProcessedPhaseData = cell(1,nDataSets);

allMeanPhases = cell(1,nDataSets);
allMeanPulsePhases = cell(1,nDataSets);
allStdPhases = cell(1,nDataSets);


for i=1:nDataSets
    dataDirectory = dataSets{i};
    disp(dataSets{i})
%     quickPhase;
%     allMeanPhases{i} = meanPhases;
%     allMeanPulsePhases{i} = meanPulsePhases;
%     allStdPhases{i} = stdPhases;
   
    % allData{i} = mergeMatMonData(dataSets{i});
   %allProcessedPhaseData{i} = extractProcessedPhaseData(allData{i},calibrationConstants);

    mergedData{i} =  mergeMatMonData(dataSets{i});
end

cd(homeDir);
return;

%%
for i=1:nDataSets

    allProcessedPhaseData{i} = extractProcessedPhaseData(mergedData{i},calibrationConstants);
    
    bpmSamples{i} = extractCTFSignalFromMergedData(bpmName,mergedData{i});

    
    allMeanPhases{i} = allProcessedPhaseData{i}.meanPhases;
    allMeanPulsePhases{i} = allProcessedPhaseData{i}.meanPulsePhases;
    allStdPhases{i} = allProcessedPhaseData{i}.stdPhases;
    
    allMeanMixers{i} = allProcessedPhaseData{i}.meanMixers;
    allMeanPulseMixers{i} = allProcessedPhaseData{i}.meanPulseMixers;
    
end


figure(1);
for i=1:nDataSets
    plot(nanmean(bpmSamples{i}));
    hold all;
end
legend(dataSetNames);
xlabel('Sample No.');
ylabel('Position [mm]');
title(bpmName);

figure(2);
tmp1 = nanmean(bpmSamples{2}) - nanmean(bpmSamples{3});
plot(tmp1);
hold all;
tmp2 = nanmean(bpmSamples{5}) - nanmean(bpmSamples{6});
plot(tmp2);
plot(tmp1-tmp2);
xlabel('Sample No.');
ylabel('Diff Position [mm]');
title('Max Gain - Min Gain, BPM930H');
legend('KICK 1','KICK 2', 'KICK 1 - KICK 2');


figure(3);
plot(tmp1);
hold all;
max(tmp1)./max(tmp2);
plot(tmp2.*(max(tmp1)./max(tmp2)));
title('Max Gain - Min Gain (2nd autoscaled to its max), BPM930H');


figure(4);
for i=1:nDataSets
    tmpMeanMixers = allMeanMixers{i};
    plot(tmpMeanMixers(3,:))
    hold all;
end
title('MIXER MEAN PHASE VS. SAMPLE NO. - MON 3');
xlabel('Sample No,');
ylabel('Output [Volts]');
legend(dataSetNames)



figure(5);
for i=1:nDataSets
    tmpMeanPhases = allMeanPhases{i};
    plot(tmpMeanPhases(3,:))
    hold all;
end
title('MEAN PHASE VS. SAMPLE NO. - MON 3');
xlabel('Sample No,');
ylabel('Phase [12GHz Degrees]');
legend(dataSetNames)

figure(6);
tmpMeanPhases1 = allMeanPhases{1};
tmpMeanPhases2 = allMeanPhases{2};
plot(tmpMeanPhases1(3,:)-tmpMeanPhases2(3,:));
title('MEAN DIFF PHASE VS. SAMPLE NO. - MON 3');
xlabel('Sample No,');
ylabel('Diff Phase [12GHz Degrees]');
legend(dataSetNames)


figure;
for i=1:nDataSets
    tmpPulsePhases = allMeanPulsePhases{i};
    plot(tmpPulsePhases(3,:));
    hold all;
end
title('MEAN PHASE VS. TIME - MON 3');
xlabel('Pulse No.');
ylabel('Phase [12GHz Degrees]');
legend(dataSetNames);

figure(7);
for i=1:nDataSets
    tmpStdPhases = allStdPhases{i};
    plot(tmpStdPhases(3,:));
    hold all;
end
title('STD PHASE VS. SAMPLE NO. - MON 3');
xlabel('Pulse No.');
ylabel('Phase [12GHz Degrees]');
legend(dataSetNames);



return;
%%
baseDir = '/home/jack/PhaseFeedforward/CTFData/';
homeDir = pwd;
addpath(homeDir);
cd(baseDir);

dataSets = {...
    '201412/20141217_1600_StaticWiggleAlong3_Gain0',...
    '201412/20141217_1530_WiggleAmplitudeAlong3',...
    '201412/20141217_1530_WiggleAmplitudeAlong3_Gain30',...
    '201412/20141217_1530_WiggleAmplitudeAlong3_Gain-30'...
};

dataSetNames = {
    'Static Wiggle',...
    'Varying Wiggle (No FF)',...
    'Varying Wiggle (FF Gain +30)',...
    'Varying Wiggle (FF Gain -30)',...
};

calFile = '201412/frascatiCalibrations/frascatiCalibrationConstants_20141216_1541';
useDiode = 0;

%%
dataSets = {...
    '201412/20141205_1200_R56_+0.5',... %K1
    '201412/20141205_1200_R56_+0.4_TimingScans_FF_K1Gain_0_K2Gain_0_noGate',...
    '201412/20141205_1330_R56_+0.3',...
    '201412/20141205_1025_TimingScans_FF_K1Gain_0_K2Gain_0_end',...
    '201412/20141205_1101_TimingScans_FF_K1Gain_26_K2Gain_-30_noGate',...
    '201412/20141205_1109_TimingScans_FF_K1Gain_-26_K2Gain_30_noGate',...
    '201412/20141205_1125_R56_-0.2_TimingScans_FF_K1Gain_26_K2Gain_-30_noGate',... 
    '201412/20141205_1125_R56_-0.2_TimingScans_FF_K1Gain_-26_K2Gain_30_noGate',...
};

dataSetNames = {
    'R56 = +0.5',...
    'R56 = +0.4',...
    'R56 = +0.3',...
    'R56 = +0.2 (1025)',...
    'R56 = +0.2 (1101)',...
    'R56 = +0.2 (1109)',...
    'R56 = -0.2 (FF On Gain+)',...
    'R56 = -0.2 (FF On Gain-)',...
};

calFile = '201412/frascatiCalibrations/frascatiCalibrationConstants_20141205_0944';
useDiode = 1;

% mergedData = {mergedData{1},mergedData{2},mergedData{3},mergedData{5},[mergedData{7} mergedData{8}]};
% dataSetNames = {
%     'R56 = +0.5',...
%     'R56 = +0.4',...
%     'R56 = +0.3',...
%     'R56 = +0.2',...
%     'R56 = -0.2',...
% };
% rawNames = dataSetNames;
% nDataSets = length(mergedData);


%%
dataSets = {...
    '201412/20141210_2035_R56_+0.3_Gate_375_435_GainK1_0_GainK2_0',...
    '201412/20141210_2035_R56_+0.3_Gate_375_435_GainK1_20_GainK2_-20',...
    '201412/20141210_2035_R56_+0.3_Gate_375_435_GainK1_40_GainK2_-40',...
    '201412/20141210_2035_R56_+0.3_Gate_375_435_GainK1_63_GainK2_-63_END',...
    '201412/20141210_2035_R56_+0.3_Gate_375_435_GainK1_-20_GainK2_20',...
    '201412/20141210_2035_R56_+0.3_Gate_375_435_GainK1_-40_GainK2_40',...
    '201412/20141210_2035_R56_+0.3_Gate_375_435_GainK1_-63_GainK2_63'...

};
    
dataSetNames = {
    'Gain = 0',...
    'Gain = +20',...
    'Gain = +40',...
    'Gain = +63',...
    'Gain = -20',...
    'Gain = -40',...
    'Gain = -63',...
};
calFile = '201412/frascatiCalibrations/frascatiCalibrationConstants_20141210_1844';

%%%%%%%%%%%%%%%%%%%%%%%%%



calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141211_1007';


% GOOD!!
dataSets = {...
'data/20141211_1950_TL1_point3_Gain30_Wiggle02',...
'data/20141211_2000_TL1_point3_Gain-30_Wiggle02',...
'data/20141211_2010_TL1_point3_Gain0_Wiggle02',...
    };


dataSetNames = {
                'MKS2 wiggle Gain=30', ... 
                'MKS2 wiggle Gain=-30', ... 
                'MKS2 wiggle Gain=0', ... 
                };


%%%%%%%%%%%%%%%%%%%%%%%%%

dataSets = {...
            'data/20141215_1823_Gate330to450_FFGain_0',...
            'data/20141215_1833_Gate330to450_FFGain_35',...
           };

dataSetNames = {
                'Gain=0',...
                'Gain=35',...
                };


calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141215_1405';


%%%%%%%%%%%%%%%%%%%%%%%%%%%
dataSets = {...
'data/20141217_0930_Gate325to450_Gain0',...
'data/20141217_1004_Gate325to450_Gain0_Wiggle23Average',...
'data/20141217_0944_Gate325to450_Gain-30_Wiggle23Average',...
'data/20141217_1004_Gate325to450_Gain-40_Wiggle23Average',...
'data/20141217_1004_Gate325to450_Gain+30_Wiggle23Average',...
    };

dataSetNames = {
                'bare',...
                'wiggle, Gain=0',...
                'wiggle, Gain=-30', ...
                'wiggle, Gain=-40', ...
                'wiggle, Gain=+30', ...
                };





%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Phase sag correction
dataSets = {...
            'data/20141215_1525_Gate290to475_FFGain_0_3DirTogether',...
            'data/20141215_1525_Gate290to475_FFGain_+30',...
            'data/20141215_1525_Gate290to475_FFGain_-30',...
           };


dataSetNames = {
                'Gain=0',...
                'Gain=+30',...
                'Gain=-30',...
                };


calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141215_1405';

%%%%%%%%%%%%%%%
% Wiggilng 3 along pulse with amplitude time shift

dataSets = {...
'data/20141216_1810_Gate325to450_Gain0_WiggleAmplitudeAlong3',...
'data/20141216_1810_Gate325to450_Gain30_WiggleAmplitudeAlong3',...
'data/20141216_1810_Gate325to450_Gain20_WiggleAmplitudeAlong3',...
    };


dataSetNames = {
                'WiggleAmpAlong3, Gain0', ... 
                'WiggleAmpAlong3, Gain30', ... 
                'WiggleAmpAlong3, Gain20', ... 
                };

        
 
calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141216_1541';



%%%%%%%%%%%%%%%%%
% Wiggling along pulse with time shift.

dataSets = {...
            'data/20141215_1823_Gate330to450_FFGain_0',...
            'data/20141215_1856_WiggleWithTimeShift_Gate330to450_FFGain_35',...
            'data/20141215_1902_WiggleWithTimeShift_Gate330to450_FFGain_0',...
            'data/20141215_1902_WiggleWithTimeShift_Gate330to450_FFGain_25',...
            };

dataSetNames = {...
                'Bare',...
                'WigAlongTime Gain=0',...
                'WigAlongTime Gain=+35',...
                'WigAlongTime Gain=0',...
                'WigAlongTime Gain=+25',...
                };
        
 
calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141215_1405';

%%%%%%%%%%%%%%%%%
% Wiggling along pulse
dataSets = {...
            'data/20141215_1610_Gate290to475_FFGain_0',...
            'data/20141215_1645_Gate290to475_WiggleAlong1_FFGain_0',...
            'data/20141215_1810_Gate330to450_WiggleAlong1_FFGain_-40',...
            'data/20141215_1730_Gate330to450_WiggleAlong1_FFGain_-30',...
            'data/20141215_1730_Gate330to450_WiggleAlong1_FFGain_30',...
            'data/20141215_1752_Gate330to450_WiggleAlong1_FFGain_+40',...
            };
dataSetNames = {
                'Bare',...
                'WigAlong',...
                'WigAlong Gain=-40',...
                'WigAlong Gain=-30',...
                'WigAlong Gain=+30',...
                'WigAlong Gain=+40',...
                };


calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141215_1405';



%%%%%%%%%%%%%%%\
calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141211_1007';

dataSets = {...
            'data/20141212_1450_Gain_-20_InjWig.3deg',...
            'data/20141212_1241_Gain_-30_InjWig.3deg',...
            'data/20141212_1240_Gain_-40_InjWig.3deg',...
            'data/20141212_1450_Gain_20_InjWig.3deg',...
            
            };
dataSetNames = {
                'Wig=.3 Gain=-20',...
                'Wig=.3 Gain=-30',...
                'Wig=.3 Gain=-40',...
                'Wig=.3 Gain=20',...
                };



%%%%%%%%%%%%%%%
calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141211_1007';

dataSets = {...
            'data/20141212_1140_Gain_0',...
            'data/20141212_1240_Gain_-23_NoWiggle',...
            'data/20141212_1130_Gain-30',... Noisy data
            'data/20141212_1240_Gain_-40_NoWiggle',...
            };
dataSetNames = {
                'Gain=0',...
                'Gain=-23',...
                'Gain=-30',...
                'Gain=-40',...
                };


             
%%%%%%%%%%%%% OK

calFile = 'data/frascatiCalibrations/frascatiCalibrationConstants_20141210_1844';

dataSets = {...
    'data/20141211_1520_TL1_point3_Gain0_Wiggle02phase',...
    'data/20141211_1805_TL1_point3_Gain0_Wiggle02phase',...
    'data/20141211_1620_TL1_point3_Gain30_Wiggle02phase',...
    'data/20141211_1805_TL1_point3_Gain30_Wiggle02phase',...
    'data/20141211_1627_TL1_point3_Gain-30_Wiggle02phase',...
    'data/20141211_1800_TL1_point3_Gain-30_Wiggle02phase',...
    };


dataSetNames = {'MKS2 wiggle Gain=0', ... 
                'MKS2 wiggle Gain=0', ... 
                'MKS2 wiggle Gain=30', ... 
                'MKS2 wiggle Gain=30', ... 
                'MKS2 wiggle Gain=-30', ... 
                'MKS2 wiggle Gain=-30', ... 
                };


%%%%%%%%%%%%%
%% OK


dataSets = {...
            'data/20141212_1140_Gain_0',...
            'data/20141212_1140_Gain_0_InjWig1deg',...
            'data/20141212_1140_Gain_-23_InjWig1deg',...
            'data/20141212_1140_Gain_-23_InjWig.5deg',...
            'data/20141212_1140_Gain_-30_InjWig.5deg',...
};
dataSetNames = {
                'Gain=0',...
                'Wig 1deg Gain=0',...
                'Wig 1deg Gain=-23',...
                'Wig 0.5 deg Gain=-23',...
                'Wig 0.5 deg Gain=-30',...
                };




%%%%%%%%%%%


dataSets = {...
    'data/20141205_0942_TimingScans_FF_K1Gain_0_K2Gain_0_end',... %K1
    'data/20141205_0942_TimingScans_FF_K1Gain_50_K2Gain_0_end',...
    'data/20141205_1015_TimingScans_FF_K1Gain_-50_K2Gain_0_end',...
    'data/20141205_1025_TimingScans_FF_K1Gain_0_K2Gain_0_end',... %K2
    'data/20141205_1020_TimingScans_FF_K1Gain_0_K2Gain_50_end',...
    'data/20141205_1023_TimingScans_FF_K1Gain_0_K2Gain_-50_end',...
    };

R56s
dataSets = {...
    'data/20141205_1200_R56_+0.5',... %K1
    'data/20141205_1200_R56_+0.4_TimingScans_FF_K1Gain_0_K2Gain_0_noGate',...
    'data/20141205_1330_R56_+0.3',...
    'data/20141205_1025_TimingScans_FF_K1Gain_0_K2Gain_0_end',...
    'data/20141205_1125_R56_-0.2_TimingScans_FF_K1Gain_26_K2Gain_-30_noGate',... 
    'data/20141205_1125_R56_-0.2_TimingScans_FF_K1Gain_-26_K2Gain_30_noGate',...
    };


dataSets = {...
    'data/20141210_1950_R56_+0.3_Gate_375_435_GainK1_0_GainK2_0',...
    'data/20141210_1950_R56_+0.3_Gate_375_435_GainK1_63_GainK2_-63',...
    'data/20141210_2020_R56_+0.3_Gate_375_435_GainK1_-63_GainK2_63',...
    };



%%
set(gcf,'units','normalized','position',[0 0 1.0 0.5])