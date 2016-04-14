%generates simple psth from OEP data extracted via kwik2mat function
%and MEDPC timestamps generated from MEDtoOEP_timealignment.m

%% set hardcoded parameters (to be put as function inputs eventually)
bin = .2; % in seconds
psthStart = -20; % seconds pre-event
psthStop = 50; % seconds post-event
eventLabel = [1,1001,2001]; % event label (or labels!!) for a particular trial type or multiple events put together
sampleRate = 25000;

%% first, load some spike data

[filename filedirectory]=uigetfile('*extracted_tms_and_wvs.mat');

cd(filedirectory)
load(filename)

%% then load some event timestamps

[filename filedirectory]=uigetfile('OEPaligned.mat');

cd(filedirectory)
load(filename)

%% align spikes to event and bin the data

steps=(psthStart:bin:psthStop);

eventsOfInterestIndex = ismember(medeventstamps,eventLabel);
numTrials = sum(eventsOfInterestIndex);

eventsOfInterst=medeventstamps(eventsOfInterestIndex);
eventtimesOfInterst=medeventtimes(eventsOfInterestIndex);

clear eventPSTH
for ii = size(spike,2):-1:1
    
    for jj = numTrials:-1:1
        
            currentTrialEvent = eventtimesOfInterst(jj);
            
            eventPSTH(ii,jj,:) = [histc(double(spike(ii).times)/sampleRate-currentTrialEvent,[psthStart:bin:psthStop])];
        
    end
       
end

plot(steps,squeeze(medfilt1(mean(eventPSTH,2),10,[],3))'/bin)
