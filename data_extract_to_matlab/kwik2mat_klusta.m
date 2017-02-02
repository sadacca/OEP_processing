%%  find the file
[filename,filedirectory]=uigetfile('*.kwik');

%goto the file directory
cd(filedirectory)

% for the first shank

clear spike
for pr = 0:7;
probe = num2str(pr);

%% find all the clusters and cluster indicies
clusternumbers = double(h5read(filename, ['/channel_groups/',probe,'/spikes/clusters/main']));
allclusters = unique(clusternumbers);

%% of these, find MUA (group 1) and GOOD (group 2) clusters

clustergroup = zeros(1,max(allclusters));

for ac = allclusters'
    thiscluster = num2str(ac);
    clustergroup(ac+1) = h5readatt([filename(1:end-3),'wik'], ['/channel_groups/',probe,'/clusters/main/',thiscluster],'cluster_group');
end

ismua = find(clustergroup == 1)-1;
isgood = find(clustergroup == 2)-1;

 isgood  = [isgood]; %uncomment if you want to treat mua as good

% extract all spiketimes from *.kwik file

allspiketimes=h5read([filename(1:end-3),'wik'], ['/channel_groups/',probe,'/spikes/time_samples']);

%get ready to put neurons into the multineuron data structure

if exist('spike','var')
    clusterindex = (1:length(isgood))+length(spike);
else
    clusterindex = 1:length(isgood);
end

%%get ready to extract select waveforms
datFilename = [filename(1:end-4),'dat'];
chansToExtract = [1 2 3 4]+(pr*4);
window = [-25 25];
nToRead = 100;
chansInDat = 32;

%% butter to filter data
fs = 25000;

Wp = [ 500 8000] * 2 / fs; % pass band for filtering
Ws = [ 300 10000] * 2 / fs; % transition zone
[N,Wn] = buttord( Wp, Ws, 3, 20); % determine filter parameters
[B,A] = butter(N,Wn); % builds filter

%slice out good waveforms into a spike.wave data structure
for cl = 1:length(isgood)
       spike(clusterindex(cl)).times = allspiketimes(clusternumbers==isgood(cl));
       
[meanWF, allWF] = readWaveformsFromDat(...
    datFilename, chansInDat, spike(clusterindex(cl)).times,...
    window, nToRead);
filtmeanWF = filtfilt(B,A,meanWF(chansToExtract,:)');
allWF = allWF(chansToExtract,:,:);
        spike(clusterindex(cl)).waves = allWF;
        figure; plot(1000*window(1)/(fs):1000/(fs):1000*window(2)/(fs),filtmeanWF)
        xlabel('ms'),ylabel('mV')
        spike(clusterindex(cl)).filtmwave = filtmeanWF;

end
end

%% save  the spike file
cd ..
save([filedirectory(end-9:end-1),'_extracted_tms_and_wvs.mat'],'spike')


