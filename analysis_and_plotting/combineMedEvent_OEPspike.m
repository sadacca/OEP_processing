
ypdirs = dir('YP*');
homed = cd;

for ii = 1:length(ypdirs)
    
    if ypdirs(ii).isdir == 1
        
        try
        
        cd(ypdirs(ii).name)
        
        spikename = ls('*_extracted_tms_and_wvs.mat');
        eventname =ls('*OEPaligned.mat');
        load(spikename)
        load(eventname)
        
        for jj = 1:length(spike) %for each neuron
            spike(jj).medtimes = medeventtimes;
            spike(jj).medlabels = medeventstamps;
        end
        
        cd ..
        save([spikename(end-4),'_wEvent.mat'],'spike')
        clear spike* event*
        catch message
            cd(homed)
           
        end
    end
end

