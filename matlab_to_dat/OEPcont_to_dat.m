function OEPcont_to_dat()
% transmute an OEP .continuous file to a raw .dat file
% no input parameters
% subtracts AUX channels (3, hardcoded)
%
% written by Brian Sadacca 12-9-2015
% last modified by ...

%% get the data
filename = dir('*CH*.continuous');

%% load the data
%get there


if length(filename)>1  % if you've got multiple channels
    for ii = 1:length(filename)
        for jj = 1:length(filename)
            if regexp(filename(ii).name,['CH',num2str(jj),'.'])
                fileindex(ii)=jj;
            end
        end
    end
    
    [xx fileorder]=sort(fileindex);
    
    %open the first channel
    
    [first_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(1)).name);
    
    
    %initialize a big matrix for the data
    incoming_data = zeros(length(filename),length(first_channel),'int16');
    
    %write the first channel to the full data matrix
    incoming_data(1,:)= int16(first_channel);
    
    
    
    for ii = 2:length(filename) %repeat for the remainder of channels
        
        
        
        [next_channel timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(ii)).name);
        
        incoming_data(ii,:)=int16(next_channel);
        
    end
    
    %initialize a new .dat file
    fid=fopen('sampledata.dat','w+');
    
    % write data to raw .dat file
    fwrite(fid,incoming_data(:,:),'int16');
    
    % close that file
    fclose(fid);
    
    %say that the job is done
    disp(['files ',filename(1).name,' to ',filename(fileorder(end)).name,' converted'])
    
    
else % else if you only have one channel or file
    
    % open the one file
    [incoming_data] = load_open_ephys_data_faster(filename(1).name);
    
    % create/open a raw file
    fid=fopen('sampledata.dat','w+');
    
    
    % write data to raw file
    fwrite(fid,incoming_data(1:end-3,:),'int16');
    
    % close that file
    fclose(fid);
    
    %say that the job is done
    disp(['file ',filename.name,' converted'])
end
exit
end


