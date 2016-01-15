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
    clustergroup(ac) = h5readatt([filename(1:end-3),'wik'], ['/channel_groups/',probe,'/clusters/main/',thiscluster],'cluster_group');
end

ismua = find(clustergroup == 1);
isgood = find(clustergroup == 2);

% isgood  = [isgood,ismua]; %uncomment if you want to treat mua as good


% extract all waveforms from *.kwx file with same name as *.kwik

allwaveforms = h5read([filename(1:end-3),'wx'], ['/channel_groups/',probe,'/waveforms_filtered']);

% extract all spiketimes from *.kwik file

allspiketimes=h5read([filename(1:end-3),'wik'], ['/channel_groups/',probe,'/spikes/time_samples']);


%get ready to put neurons into the multineuron data structure
if exist('spike','var')
    clusterindex = (1:length(isgood))+length(spike);
else
    clusterindex = 1:length(isgood);
end

%slice out good waveforms into a spike.wave data structure
for cl = 1:length(isgood)
    spike(clusterindex(cl)).waves = allwaveforms(:,:, clusternumbers==isgood(cl));
    spike(clusterindex(cl)).times = allspiketimes(clusternumbers==isgood(cl));
end
end

%% plot each neuron simply

clr = [0,0.4470,0.7410;...
    0.8500,0.3250,0.0980;...
    0.9290,0.6940,0.1250;...
    0.4940,0.1840,0.5560];

for ii = 1:length(spike) %for each neuron
    figure;
    for jj = 1:4 %tetrodes
     plot(squeeze(mean(spike(ii).waves(jj,:,:),3)),'color',clr(jj,:)),hold on
    end
end



