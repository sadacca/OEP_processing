function MEDtoOEP_timealignment()
%  data alignment for syncing MEDPC to OEP timestamps for use with OEP waveforms
%   by BS 04/14/16
%

%% load files
%  find the medfile
[medfilename,medfiledirectory]=uigetfile('*.mat');

%goto the file directory
cd(medfiledirectory)

load(medfilename);

% find the OEP file
[oepfilename,oepfiledirectory]=uigetfile('*.mat');

%goto the file directory
cd(oepfiledirectory)

load(oepfilename);

%% find and scale timestamps

medPConTimes = sort(medeventtimes(medeventstamps == 1 | medeventstamps == 1001 | medeventstamps == 2001));
medPConTimes = medPConTimes/100; %rescaling to seconds

%% shift medtimes to match OEP clock

[slopeandoffset]=polyfit(sort(medPConTimes),OEPon,1); %% there may be a bit of drift (80ms per hour of recording)
medeventtimes = (medeventtimes/100)*slopeandoffset(1) + slopeandoffset(2);


save([medfilename(1:end-4),'OEPaligned.mat'],'medevent*')








