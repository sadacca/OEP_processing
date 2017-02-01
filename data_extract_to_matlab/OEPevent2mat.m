function OEPevent2mat()
% transmute an OEP .event file into a matlab file
% no input parameters
% extracts event#3 hardcoded
%
% written by Brian Sadacca 3-21-2016
% last modified by ...

%% get the data, assuming you're in the right directory
filename = dir('all_channels.events');
filedirectory = cd;

%% load the data
%get there

[eventlabel, timestamps, info_events] = load_open_ephys_data_faster(filename.name);
OEPon=timestamps((info_events.eventId == 0) & (info_events.eventType == 3));
OEPoff=timestamps((info_events.eventId == 1) & (info_events.eventType == 3));
    
    

save([filedirectory,'_extracted_event_times.mat'],'OEP*','timestamps')

%exit
end


