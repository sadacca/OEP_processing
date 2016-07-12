function OEPcont_to_dat_wFilter()
% transmute an OEP .continuous file to a raw .dat file
% no input parameters
%
% written by Brian Sadacca 3-21-2016
% last modified by ...

%% get the data
filename = dir('*CH*.continuous');

%% load the data


    for ii = 1:length(filename)
        for jj = 1:length(filename)
            if regexp(filename(ii).name,['CH',num2str(jj),'.'])
                fileindex(ii)=jj;
            end
        end
    end
    
    [xx fileorder]=sort(fileindex);
    
    
    %initialize a big matrix for the data
    incoming_data = zeros(length(filename),length(first_channel),'int16');
    
    %write the first channel to the full data matrix
    incoming_data(1,:)= int16(first_channel);
    
    clear first_channel
    
    for ii = 2:length(filename) %repeat for the remainder of channels
        
        [next_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(ii)).name);
        
        incoming_data(ii,:)=int16(next_channel);
        
    end
    
    clear timestamps,clear next_channel
    
    %create a common average reference
    
    ref_channel = squeeze(sum(incoming_data,1,'double')/size(incoming_data,1));
    
    % subtract the mean from all channels
    
    for ii = 1:length(filename)
        incoming_data(ii,:) = incoming_data(ii,:) - ref_channel;
    end
    
    
    
    %% Design and apply the bandpass filter
    
samp=25000;          % Sample rate in ms
     
low_cut = 150;       % in hz
low_butter=low_cut/samp;
butter_order = 2;
    [b,a] = butter(butter_order, [low_butter 0.5]);

    for ii = 1:length(fileindex)
        
       % s = squeeze(single(incoming_data(ii,:)));
        x= filtfilt(b,a,squeeze(double(incoming_data(ii,:))));

        
        
        %% chop out all the big stuff: set hard floors and ceilings @ +/- 200
        
        x(x>800)=0;
        x(x<-800)=0;
        
        incoming_data(ii,:)=int16(x);
        
    end
    
    %initialize a new .dat file
    fid=fopen('sampledata.dat','w+');
    
    % write data to raw .dat file
    fwrite(fid,incoming_data(:,:),'int16');
    
    % close that file
    fclose(fid);
    
    %say that the job is done
    disp(['files ',filename(1).name,' to ',filename(fileorder(end)).name,' converted'])
    
    
    exit



