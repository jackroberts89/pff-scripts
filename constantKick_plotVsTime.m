dataDir = '/nfs/cs-ccr-nfs6/vol29/share/ctf/data/ctfmod/MatLab/PhaseFeedforward/data/20141118_1830_TrigOutDelay_100_DAC1Gain_63_Kick1_FFInterleaved';

bpmNames = {...
    'CC.SVBPM0435H',...
    'CC.SVBPI0535H',...
    'CC.SVBPI0645H',...
    'CC.SVBPI0685H',...
    'CC.SVBPI0735H',...
    'CC.SVBPM0845H',...
    'CC.SVBPM0930H',...
    'CB.SVBPM0150H',...
    'CB.SVBPS0210H',...
    'CB.SVBPS0250H',...
    'CB.SVBPS0310H'...
};
bpmIndexToPlot = 6;

CTFData = mergeMatMonData(dataDir);

nPulses = length(CTFData);
nBPMs = length(bpmNames);

bpmPositions = NaN*ones(nBPMs, nPulses);
%kickSettings = NaN*ones(1, nPulses);

for t=1:nPulses
    for bpm=1:nBPMs
        eval(['bpmPositions(bpm,t) = CTFData(t).' bpmNames{bpm} '.MeanAtCursor.mean.value;']);
    end
end

plot(squeeze(bpmPositions(bpmIndexToPlot,:)),'o');