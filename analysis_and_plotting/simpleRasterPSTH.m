
%plot example neuron (1b-c) and mean correlation (1d)

%(note: 1d requires you to have calculated HMM transitions for real data)
%and have those transitions in the workspace (i.e. have run shiftPSTH_to_STATE.m)
%% load the spike data

names=what;
numFiles = length(names.mat);
ff=1;
for ff = 1:numFiles
   load(names(ff).mat)
   eval(['spike',num2str(ff),'=)
end
names1 = whos ('spike*');

for ii = 1:length(names1)
    if ii ==1
        site = [eval(names1(ii).name)];
        
    else
        site = [site;eval(names1(ii).name)];
        
    end
    
end


%% initialize hard-coded parameters

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% choose plotting/binning paramters

psthStart=-1; %analysis start (seconds)
psthStop=5;   %analysis stop (seconds)
bin = .05;     %PSTH bin size (seconds)

steps=(psthStart:bin:psthStop);
sampleRate = 25000;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% choose events worth looking at

eventLabel = {... % event label (or labels!!) for a particular trial type or multiple events put together
    [1,1001,2001],... % first event set
    [1,1001,2001],... % second event set
    [1,1001,2001]};   % third event set

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% choose colors for events

clr=[.1 .9 .5;... %events 1 (black)
    .8 .1 .1;...  %events 2 (gray)
    .1 .6 .8;...  %events 3 (blue)
    .7 .6 .2];    %events 4 (red)

%% align the spikes to events of interest, for inclusion into a 4d matrix
% psth4d -- a neuron x trialtype x trial# x time matrix

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first get # neurons, trial types, trial #s and initialize 4d matrix 

clear eventPSTH

numNeurons = length(spike);
numTrialTypes = length(eventLabel);
numBins = length(steps);

for ii = numNeurons:-1:1
    for jj = numTrialTypes;
        
        eventsOfInterestIndex = ismember(medeventstamps,eventLabel{kk});
        numTrials(ii,jj) = sum(eventsOfInterestIndex);
        
    end
end

psth4d = NaN(numNeurons,numTrialTypes,max(numTrials(:)),numBins);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now fill the intialized matrix with spike counts per bin


for ii = size(spike,2):-1:1
    for jj = length(eventLabel);
        
        for kk = numTrials:-1:1
            
            currentTrialEvent = eventtimesOfInterst(kk);
            
            eventPSTH(ii,kk,:) = histc(double(spike(ii).times)/sampleRate-currentTrialEvent,psthStart:bin:psthStop);
            
        end
    end
end

%% initialize variables

%% bin spikes into PSTH



avgpsth = zeros(size(site,1),size(site,2),size(psth_spc2,4));


%% plot spikes on a trial-by-trial basis


starttime = 19;
endtime = 25;

steps = [starttime:.001:endtime];
maxtrials = 10;
spikeduration = 0;
%for cue onset

for nrn = neurons
    cuect=0;
    figure((nrn*100));
    
    
    
    for cue = cues
        for tr=1:length(site(nrn,cue).trials)
            
            %%plot spiketrains
            
            realspiketr = (site(nrn,cue).trials(tr).times(site(nrn,cue).trials(tr).times>starttime & site(nrn,cue).trials(tr).times<endtime))-20;
            cuect=cuect+1;
            
            xx = realspiketr;
            yy = ones(size(xx));
            xx= xx'; yy = yy';
            xpoints = [xx;xx+spikeduration;NaN(size(xx))];
            ypoints = [yy+cuect-.4;yy+cuect+.4;NaN(size(yy))];
            xpoints = xpoints(:);
            ypoints = ypoints(:);
            
            subplot(2,2,1)
            hold on,
            
            plot(xpoints,ypoints,'color',clr(cue,:))
            
            xlim([steps(1),steps(end)]-20)
            
        end
    end
    
    
    plot([1,1],[1.1,tr+.9],'k--'),plot([0,0],[1.1, cuect+.9],'k--')
    plot([0,0],[1.1,tr+.9],'k--'),plot([0,0],[1.1, cuect+.9],'k--')
    xlabel('seconds from cue'),
    ylabel('trial #')
end



starttime = 25;
endtime = 31;

steps = [starttime,endtime];
maxtrials = 10;

%for cue offset

for nrn = neurons
    cuect=0;
    figure((nrn*100));
    
    
    for cue = cues
        for tr=1:length(site(nrn,cue).trials)
            
            %%plot spiketrains
            
            realspiketr = (site(nrn,cue).trials(tr).times(site(nrn,cue).trials(tr).times>starttime & site(nrn,cue).trials(tr).times<endtime))-20;
            cuect=cuect+1;
            
            xx = realspiketr;
            yy = ones(size(xx));
            xx= xx'; yy = yy';
            xpoints = [xx;xx+spikeduration;NaN(size(xx))];
            ypoints = [yy+cuect-.4;yy+cuect+.4;NaN(size(yy))];
            xpoints = xpoints(:);
            ypoints = ypoints(:);
            
            subplot(2,2,2)
            hold on,
            
            plot(xpoints,ypoints,'color',clr(cue,:))
            
            xlim([steps(1),steps(end)]-20)
            
        end
    end
    
    plot([10,10],[1.1,tr+.9],'k--'),plot([0,0],[1.1,cuect+1],'k--')
    xlabel('seconds from cue'),
    ylabel('trial #')
end




for nrn = neurons%1:size(site,1)
    figure((nrn*100));
    subplot(2,2,3:4)
    for st = cues
        
        clr=[.1 .9 .5;... %siren
            .8 .1 .1;...  %tone
            .1 .6 .8;...  %clicker
            .7 .6 .2];    %whitenoise
        
        plot(-20:bin:60,sgolayfilt(squeeze(mean(squeeze(psth_spc2(nrn,st,:,:)),1))',2,51)/bin,'color',clr(st,:),'linewidth',2)
        %plot(-20:bin:60,smooth(squeeze(mean(squeeze(psth_spc2(nrn,st,:,:)),1))',1/bin,'lowess')/bin,'color',clr(st,:),'linewidth',2)
        hold on
        
        
        %COMPILE AVERAGEPSTHS
        
    end
    xlim([-15 40]), legend(['b+';'d-';'a ';'c '])
    xlabel('seconds from cue')
    ylabel('spikes/second')
    
    plot([1,1],[0,30],'k--'),plot([0,0],[0,30],'k--'),plot([10,10],[0,30],'k--')
    
    
end
