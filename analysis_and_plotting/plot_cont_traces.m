
%% get the data
filename = dir('*CH*.continuous');

%% load the data
%get there


if length(filename)>1  % if you've got multiple channels
    
    %open the first channel
    
    [first_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(1).name);
    
    
    %initialize a big matrix for the data
    incoming_data = zeros(length(filename),length(first_channel),'int16');
    
    %write the first channel to the full data matrix
    incoming_data(1,:)= int16(first_channel);
    
    
    for ii = 2:length(filename) %repeat for the remainder of channels
        

    
    [next_channel timestamps, info_continuous] = load_open_ephys_data_faster(filename(ii).name);
    
    incoming_data(ii,:)=int16(next_channel);
        
    end
end
    
    %plot 1 second of data
    figure;
    timevec = 0:1/25000:.25;
    timestart = 31000;
    mm = size(incoming_data,1);
    for ii = 2:size(incoming_data,1)
    plot(timevec,ii*4.7+zscore(single(incoming_data(ii,timestart:timestart+length(timevec)-1))),'color',[ii/mm 0 1/ii],'lineWidth',.5),hold on
    end