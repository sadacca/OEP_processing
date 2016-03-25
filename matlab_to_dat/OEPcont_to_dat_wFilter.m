function OEPcont_to_dat_wFilter()
% transmute an OEP .continuous file to a raw .dat file
% no input parameters
% subtracts AUX channels (3, hardcoded)
%
% written by Brian Sadacca 12-9-2015
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
    
    %open the first channel
    
    [first_channel, timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(1)).name);
    
    
    %initialize a big matrix for the data
    incoming_data = zeros(length(filename),length(first_channel),'int16');
    
    %write the first channel to the full data matrix
    incoming_data(1,:)= int16(first_channel);
    
    clear first_channel
    
    for ii = 2:length(filename) %repeat for the remainder of channels
        
        
        
        [next_channel timestamps, info_continuous] = load_open_ephys_data_faster(filename(fileorder(ii)).name);
        
        incoming_data(ii,:)=int16(next_channel);
        
    end
    
    incoming_data = incoming_data*info_continuous.header.bitVolts;
    
    clear next_channel
    clear timestamps
    
    
    %% Design and apply the bandpass filter
    
    %fs = info_continuous.header.sampleRate; % sampling frequency
    
    %fcutlow  = 60;
    %fcuthigh = 8000;
    
%     d = designfilt('highpassiir', ...       % Response type
%         'StopbandFrequency',fcutlow, ...     % Frequency constraints
%         'PassbandFrequency',fcutlow+100, ...
%         'StopbandAttenuation',40, ...    % Magnitude constraints
%         'PassbandRipple',.3, ...
%         'DesignMethod','cheby1', ...     % Design method
%         'MatchExactly','stopband', ...   % Design method options
%         'SampleRate',fs);               % Sample rate
     
    [b,a] = butter(4, [0.007 0.5]);

    for ii = 1:length(fileindex)
        
       % s = squeeze(single(incoming_data(ii,:)));
        x= filtfilt(b,a,squeeze(double(incoming_data(ii,:))));

        
        
        %% chop out all the big stuff: set hard floors and ceilings @ +/- 200
        
        x(x>200)=200;
        x(x<-200)=-200;
        
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



