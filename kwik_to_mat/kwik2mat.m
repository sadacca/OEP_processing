% find the file
[filename,filedirectory]=uigetfile('*.kwik');

%goto the file directory
cd(filedirectory)

% for the first shank
pr = 0;
probe = num2str(pr);

%find all the clusters and cluster indicies
clusternumbers = double(h5read(filename, ['/channel_groups/',probe,'/spikes/clusters/main']));
allclusters = unique(clusternumbers);

%of these, find MUA (group 1) and GOOD (group 2) clusters

clustergroup = zeros(1,max(allclusters));

for ac = allclusters
    thiscluster = num2str(ac);
    clustergroup(ac) = h5readatt([filename(1:end-3),'wik'], ['/channel_groups/',probe,'/clusters/main/',num2str(tcluster)]);
    
end

% extract all waveforms from *.kwx file with same name as *.kwik

allwaveforms = h5read([filename(1:end-3),'wx'], ['/channel_groups/',probe,'/waveforms_filtered']);


%slice out mua/good waveforms into a spike.mua/spike.good data structure
unit36_waveforms = allwaveforms(:,:, clusternumbers==36);
