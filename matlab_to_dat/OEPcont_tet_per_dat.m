function OEPcont_tet_per_dat()
% transmute an OEP .continuous file to a raw .dat file
% no input parameters
% subtracts AUX channels (3, hardcoded)
%
% written by Brian Sadacca 12-9-2015
% last modified by ...

%% get the data
filename = dir('*_CH*.continuous');
tetrodes = [19,24,25,26;...
    18,27,28,29;...
    0,2,30,31;...
    1,3,4,13;...
    5,6,7,12;...
    8,9,10,11;
    14,15,16,17;...
    20,21,22,23]+1;
%% load the data
%get there
%open the first channel
[first_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(1).name);

for ii = 1:length(tetrodes)
    
%initialize a big matrix for the data
incoming_data = zeros(4,length(first_channel));

    for jj = 1:4 %repeat for the remainder of channels
        
        tetrode = tetrodes(ii,jj);
        
        [incoming_data(jj,:), timestamps, info_continuous] = load_open_ephys_data_faster(filename(tetrode).name);
        
        
    end
    
    %initialize a new .dat file
    fid=fopen(['sampledata',num2str(ii),'.dat'],'w+');
    
    % write data to raw .dat file
    fwrite(fid,incoming_data(:,:),'int16');
    
    % close that file
    fclose(fid);
    
    %say that the job is done
    disp(['files ',filename(1).name,' to ',filename(end).name,' converted'])
end
end