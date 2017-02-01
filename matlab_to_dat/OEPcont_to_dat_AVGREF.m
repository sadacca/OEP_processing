function OEPcont_to_dat_AVGREF()
% transmute an OEP .continuous file to a raw .dat file
% no input parameters
%
% written by Brian Sadacca 3-31-2016
% last modified by ...

%% get the data
filename = dir('*CH*.continuous');

%% make sure there's a proper number of channels - proper being 32

if rem(length(filename),32)
    error('there are not groups of 32channels -- data missing or extra')
end

headstage_num = length(filename)/32;
 
%% sort the data into proper indices

for ii = 1:length(filename)
    for jj = 1:length(filename)
        if regexp(filename(ii).name,['CH',num2str(jj),'.'])
            fileindex(ii)=jj;
        end
    end
end

[xx fileorder]=sort(fileindex);

%% load the data headstage by headstage and use mean as average ref
for hh = 1:headstage_num
    
    
    %open the first channel
    
    [first_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(hh*32-31)).name);
    
    
    %initialize a big matrix for the data
    incoming_data = zeros(32,length(first_channel(1:1000000)),'int16');
    
    %write the first channel to the full data matrix
    incoming_data(1,:)= int16(first_channel(1:1000000));
    
    clear first_channel
    clear timestamps
    
    for ii = 2:32 %repeat for the remainder of channels
        
        [next_channel, ~, ~] = load_open_ephys_data_faster(filename(fileorder(ii+hh*32-32)).name);
        
        incoming_data(ii,:)=int16(next_channel(1:1000000));
        
    end
    
    clear next_channel
    
    %create a common average reference
    
    ref_channel = squeeze(sum(incoming_data,1,'double')/32);
    
    % subtract the mean from all channels
    ref_channel = int16(ref_channel);
    
    for ii = 1:32
        incoming_data(ii,:) = incoming_data(ii,:) - ref_channel;
    end
    
    clear ref_channel
    
    %initialize a new .dat file
    fid=fopen(['sampledata',num2str(hh),'.dat'],'w+');
    
    % write data to raw .dat file
    fwrite(fid,incoming_data(:,:),'int16');
    
    % close that file
    fclose(fid);
    
    %say that the job is done
    disp(['headstage ',num2str(hh),' converted'])
    
    clear incoming_data
end
exit
end


