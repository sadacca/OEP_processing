

function [meanWF, allWF] = readWaveformsFromDat(datFilename, chansInDat, sampleTimes, window, nToRead)

FileInf = dir(datFilename);
nSampsInDat = (FileInf.bytes/chansInDat/2);
rawData = memmapfile(datFilename, 'Format', {'int16', [chansInDat, nSampsInDat], 'x'});

if isempty(nToRead)
    theseTimes = sampleTimes;
    nToRead = length(sampleTimes);
else
    if nToRead>length(sampleTimes)
        nToRead = length(sampleTimes);
    end
    q = randperm(nToRead);
    theseTimes = sampleTimes(sort(q(1:nToRead)));
end

theseTimes = theseTimes(theseTimes>-window(1) & theseTimes<nSampsInDat-window(2)-1);
nToRead = numel(theseTimes);

allWF = zeros(chansInDat, diff(window)+1, nToRead, 'int16');

for i=1:nToRead
    allWF(:,:,i) = double(rawData.Data.x(1:chansInDat,theseTimes(i)+window(1):theseTimes(i)+window(2)));
end

meanWF = mean(allWF,3);

