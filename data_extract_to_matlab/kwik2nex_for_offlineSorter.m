%% script to save kwik data into a plx readable format
%  while theoretically useful for crossvalidation, not practical for 
%  spike sorting, as PCA in offline sorter doesn't == pca in matlab for
%  these waveforms, among other reasons -- however fine as proof of concept
%  and a starting point for a better implemented sorting approach 
%  could append multiple tetrodes to single file, but large files become
%  unweildy, so watch out...
%
%  NOTE: there are dependancies on neuroexplorer's sdk (circa 2016)
%  for functions nexCreateDataFile, writeNexData, etc. 
%  drafted by BS 2/18/2017

%%  find the file
[filename,filedirectory]=uigetfile('*.kwik');

% create a butterworth filter to filter data
fs = 25000;  %sample frequency
lowfreqcut = 325; %where to put the cutoff on the highpass filter

Wn = (lowfreqcut/(fs/2));
[B,A] = butter(5,Wn,'high');


% for the first shank

for pr = 0:7;
    
    %goto the file directory
    
    cd(filedirectory)
    probe = num2str(pr);
    
    % find all the clusters and cluster indicies
    
    clusternumbers = double(h5read(filename, ['/channel_groups/',probe,'/spikes/clusters/main']));
    
    
    % extract all spiketimes from *.kwik file
    
    allspiketimes=h5read([filename(1:end-3),'wik'], ['/channel_groups/',probe,'/spikes/time_samples']);
    
    
    %%get ready to extract select waveforms
    
    datFilename = [filename(1:end-4),'dat'];
    chansToExtract = [1 2 3 4]+(pr*4);
    window = [-10 21];
    nToRead = length(allspiketimes);
    chansInDat = 32;
    
    
    %slice out waveforms into a new variable
    
    [meanWF, allWF] = readWaveformsFromDat(...
        datFilename, chansInDat, allspiketimes,...
        window, nToRead);
    
    
    %bring those waveforms into a double for filtering
    
    allWF = double(allWF(chansToExtract,:,:));
    
    
    %filter those waveforms for each channel
    for ch = 4:-1:1
        allspikewaves(ch,:,:) = filtfilt(B,A,squeeze(allWF(ch,:,:)));
    end
    
    %put the data where they belong
    cd ..
    
    % concatinate tetrodes into a matrix
    ordered_allspikewaves = [squeeze(allspikewaves(1,:,:));...
        squeeze(allspikewaves(2,:,:));...
        squeeze(allspikewaves(3,:,:));...
        squeeze(allspikewaves(4,:,:))];
    
    % save files with neuroexplorer sdk (from nex website)
        
    	
			temp = nexCreateFileData(fs);
			temp = nexAddWaveform(temp, fs, allspiketimes, ordered_allspikewaves, 'wave1');
			writeNexFile(temp, [filedirectory(end-9:end-1),'_TT',probe,'_extracted_tms_and_wvs.nex']);
            
    clear allspikewaves allspiketimes
    
end




