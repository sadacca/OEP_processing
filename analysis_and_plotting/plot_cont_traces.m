tic
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
end
    
    %% plot 1 second of data, and tetrode relatedness
    
      
    timestart = 100000;
    mm = size(incoming_data,1);
    fs = 30000; % sampling frequency
      timevec = 0:1/fs:10;
    
    
% Design and apply the bandpass filter
x = zeros(size(incoming_data(:,timestart:timestart+length(timevec)-1)));

fcutlow  = 4500;
fcuthigh = 6000;

d = designfilt('highpassiir', ...       % Response type
       'StopbandFrequency',fcutlow, ...     % Frequency constraints
       'PassbandFrequency',fcutlow+500, ...
       'StopbandAttenuation',400, ...    % Magnitude constraints
       'PassbandRipple',40, ...
       'DesignMethod','cheby1', ...     % Design method
       'MatchExactly','stopband', ...   % Design method options
       'SampleRate',25000);               % Sample rate
   
for ii = 1:length(fileindex)
    s = single(incoming_data(ii,timestart:timestart+length(timevec)-1));
x(ii,:)        = filter(d,s);
end

    figure;
    subplot(2,1,1)

    for ii = 1:size(incoming_data,1)
    plot(timevec,ii*4.7+zscore(s'),'color',[ii/mm 0 1/ii],'lineWidth',.5),hold on
    end
    
    subplot(2,1,2)
     within_tetrode_correlation = corr(zscore(single(incoming_data(:,timestart:20:timestart+length(timevec)-1)))','type','Pearson');
imagesc(within_tetrode_correlation(:,:).^4)
  
    
    %% resort and plot data based on forwards and backwards tetrode layouts
    
    tetind=[19,24,25,26,18,27,28,29,0,2,30,31,1,3,4,13,5,6,7,12,8,9,10,11,14,15,16,17,20,21,22,23]+1; % indexing for forward tetrodes
    tetbkind=[3,8,9,10,2,11,12,13,16,18,14,15,17,19,20,29,21,22,23,28,24,25,26,27,30,31,0,1,4,5,6,7]+1; % indexing for backwards tetrodes
    within_tetrode_correlation; corr(zscore(single(incoming_data(:,timestart:10:timestart+length(timevec)-1)))');
    figure;subplot(2,2,1);
  
    for ii = 1:size(incoming_data,1)
    plot(timevec,ii*4.7+zscore(single(incoming_data(tetind(ii),timestart:timestart+length(timevec)-1))),'color',[ii/mm 0 1/ii],'lineWidth',.5),hold on
    end
    
    subplot(2,2,3)
    imagesc(within_tetrode_correlation(tetind,tetind).^4)
subplot(2,2,2)

    for ii = 1:size(incoming_data,1)
    plot(timevec,ii*4.7+zscore(single(incoming_data(tetbkind(ii),timestart:timestart+length(timevec)-1))),'color',[ii/mm 0 1/ii],'lineWidth',.5),hold on
    end
    
subplot(2,2,4)
imagesc(within_tetrode_correlation(tetbkind,tetbkind).^4)
toc