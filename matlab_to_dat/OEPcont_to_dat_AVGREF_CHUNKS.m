function OEPcont_to_dat_AVGREF_CHUNKS()
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

%% find how many chunks we're going to need for this session
samplerate = 30000;
chunk_size = 60*60*samplerate;

[first_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(1)).name);

session_length =length(first_channel);

num_chunks = ceil(session_length/chunk_size);

%% load the data headstage by headstage, by half-hour of recording, and use mean as average ref
for hh = 1:headstage_num
    for chunk_number = 1:num_chunks
        
        if chunk_number<num_chunks
            chunk_index = chunk_number*chunk_size-(chunk_size-1):chunk_number*chunk_size;
        else
            chunk_index = chunk_number*chunk_size-(chunk_size-1):session_length;
        end
        
        %open_the_first_channel
        [first_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(hh*32-31)).name);
        
        
        %initialize a big matrix for the data
        incoming_data = zeros(32,length(first_channel(chunk_index)),'int16');
        
        %write the first channel to the full data matrix
        incoming_data(1,:)= int16(first_channel(chunk_index));
        
        clear first_channel
        clear timestamps
        
        for ii = 2:32 %repeat for the remainder of channels
            
            [next_channel, ~, ~] = load_open_ephys_data_faster(filename(fileorder(ii+hh*32-32)).name);
            
            incoming_data(ii,:)=int16(next_channel(chunk_index));
            
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
        if chunk_number ==1
            %initialize a new .dat file
            fid=fopen(['sampledata',num2str(hh),'.dat'],'w+');
        else
            %initialize a new .dat file
            fid=fopen(['sampledata',num2str(hh),'.dat'],'a+');
        end
        % write data to raw .dat file
        fwrite(fid,incoming_data(:,:),'int16');
        
        % close that file
        fclose(fid);
        
        %say that the job is done
        disp(['headstage ',num2str(hh),' converted'])
        
        clear incoming_data
    end
end
exit
end


