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

%% align timestamps
% first find the medpc timestamps that correspond with onset of TTLs
% for yann's 2016 spring recordings that's 1, 1001, and 2001

medPConTimes = eventtimes(eventstamps == 1 | eventstamps == 1001 | eventstamps == 2001);
medOEPdiff = medPConTimes - OEPon; %% ARE BOTH SCALED APPROPRIATELY?!?!

%% validate there is no shift in timestamps across session

uniquecheck=unique(medOEPdiff); 

if uniquecheck>1
	error('DANGER: there may be data loss or a clock shift between TTLs')
end

%% shift medtimes to match OEP clock

eventtimes = eventtimes - medOEPdiff;

save([medfilename],'OEPaligned.mat',eventstamps,eventtimes)

exit






