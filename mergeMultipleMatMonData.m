dataDirs = {...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1815_Gun135',...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1824_Gun135',...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1833_Gun135',...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1837_Gun135',...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1840_Gun135',...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1843_Gun135',...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1846_Gun135',...
    '/home/jack/PhaseFeedforward/CTFData/201509/20150930_1850_Gun135'...
};

for i=1:length(dataDirs)
    mergeMatMonData(dataDirs{i})
end