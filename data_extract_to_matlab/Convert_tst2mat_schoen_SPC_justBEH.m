%%%pick the directory to start hunting for files
clear all;close all
tic
%% find the files of interest
[filename pathname]=uigetfile('*.tst','Get ALL tst files','MultiSelect','on');
%[sfilename spathname]=uigetfile('*.plx','Get ALL savings files','MultiSelect','on');

%% label files of interest properly (i.e. C+ D-, VS/VTA/OFC)

cuesortflag=1;
ploton = 1;
maninput = 0;

subtype=zeros(length(filename),1);
recording_1to8=zeros(length(filename),1);
recording_9to16=zeros(length(filename),1);

trialtype = input(['what kind of sessions are these? shaping==1, precond.==2, cond.==3, probe==4, savings==5: ']);

runtype = input(['what run number are these? 1:3(vta), 4(ofc),or 7(cocaine)?: ']);

if maninput   % Manually assign cue number for each session, in light of counterbalancing
    if runtype == 1;
        if iscell(filename)
            for pp=1:length(filename)
                subtype(pp) = input(['which cue was (A)',filename{pp},'? siren==1 or tone==2:  ']);
                subtype2(pp) = input(['which cue was (C)',filename{pp},'? WN==3 or CL==4:  ']);
                subtype3(pp) = input(['which cue was (B+)',filename{pp},'? siren==1 or tone==2:  ']);
                subtype4(pp) = input(['which cue was (D)',filename{pp},'? WN==3 or CL==4:  ']);
                recording_1to8(pp) = 3;%input(['where were wires 1-8 ',filename{pp},' located? VTA==1, VS==2, OFC==3:  ']);
                recording_9to16(pp) = 3;% input(['where were wires 9-16 ',filename{pp},' located? VTA==1, VS==2, OFC==3:  ']);
            end
        else
            subtype = input(['which cue was B+ ',filename,'? siren==1 and tone==2:  ']);
            subtype2 = input(['which cue was A ',filename,'? WN==1 and CL==2:  ']);
            subtype3 = input(['which cue was (D-)',filename{pp},'? siren==1 or tone==2:  ']);
            subtype4 = input(['which cue was (C)',filename{pp},'? WN==3 or CL==4:  ']);
            recording_1to8 = 3;%input(['where were wires 1-8 ',filename,' located? VTA==1, VS==2, OFC==3:  ']);
            recording_9to16 = 3;%input(['where were wires 9-16 ',filename,' located? VTA==1, VS==2, OFC==3:  ']);
        end
    elseif runtype ==2;
        if iscell(filename)
            for pp=1:length(filename)
                subtype(pp) = input(['which cue was (B+)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
                subtype2(pp) = input(['which cue was (A)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
                subtype3(pp) = input(['which cue was (D-)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
                subtype4(pp) = input(['which cue was (C)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
                recording_1to8(pp) = 3;%input(['where were wires 1-8 ',filename{pp},' located? VTA==1, VS==2, OFC==3:  ']);
                recording_9to16(pp) = 3;% input(['where were wires 9-16 ',filename{pp},' located? VTA==1, VS==2, OFC==3:  ']);
            end
        else
            subtype = input(['which cue was (B+)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
            subtype2 = input(['which cue was (A)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
            subtype3 = input(['which cue was (D-)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
            subtype4 = input(['which cue was (C)',filename{pp},'? Alien-1 Chord-2 Sweep-3 Wobble-4:  ']);
            recording_1to8 = 3;%input(['where were wires 1-8 ',filename,' located? VTA==1, VS==2, OFC==3:  ']);
            recording_9to16 = 3;%input(['where were wires 9-16 ',filename,' located? VTA==1, VS==2, OFC==3:  ']);
        end
    elseif runtype ==3;
        if iscell(filename)
            for pp=1:length(filename)
                subtype(pp) = input(['which cue was (B+)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
                subtype2(pp) = input(['which cue was (A)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
                subtype3(pp) = input(['which cue was (D-)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
                subtype4(pp) = input(['which cue was (C)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
                recording_1to8(pp) = 3;%input(['where were wires 1-8 ',filename{pp},' located? VTA==1, VS==2, OFC==3:  ']);
                recording_9to16(pp) = 3;% input(['where were wires 9-16 ',filename{pp},' located? VTA==1, VS==2, OFC==3:  ']);
            end
        else
            subtype = input(['which cue was (B+)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
            subtype2 = input(['which cue was (A)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
            subtype3 = input(['which cue was (D-)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
            subtype4 = input(['which cue was (C)',filename{pp},'? Future-1 Train-2 ToneR-3 Pulsed-4:  ']);
            recording_1to8 = 3;%input(['where were wires 1-8 ',filename,' located? VTA==1, VS==2, OFC==3:  ']);
            recording_9to16 = 3;%input(['where were wires 9-16 ',filename,' located? VTA==1, VS==2, OFC==3:  ']);
        end
    else
        error('error - no RUNTYPE');
    end
    
else  %%for Automated input
    if iscell(filename)
        for pp=1:length(filename)
            
            
            
            animalIDnumber = str2double(filename{pp}(3:4));
            if isnan(animalIDnumber)
                warning('there is a bad rat number (NaN), file mislabeled')
                animalIDnumber = input('which rat number is this? (e.g. 32, 50): ');
            end
            
            fiD = fopen(['RUN',num2str(runtype),'.csv']);
            animaltextinput=textscan(fiD,'%s%s%s%s%s','Delimiter',',;');
            %NUMB = input(['which rat is this - ', animaltextinput{1}{2:end}','?:']);
            
            for jj = 2:length(animaltextinput{1})
                CSVNumbers(jj) = str2double(animaltextinput{1}{jj}(3:4));
            end
            
            [xx NUMB] = find(CSVNumbers==animalIDnumber);
            
            
            RUNtypes{1} = {'Siren','Tone','WN','Click'};
            RUNtypes{2} = {'Alien','Chord','Sweep','Wobble'};
            RUNtypes{3} = {'Future','Train','Tone','Pulsed'};
            RUNtypes{4} = {'Siren','Tone','WN','Click'};
            RUNtypes{7} = {'Siren','Tone','WN','Click'};
             
            for ii = 1:4
                xxx{ii}=animaltextinput{ii+1}{NUMB};
            end
            
            for jj = 1:4
                if strcmp(RUNtypes{runtype}{jj},xxx{1});
                    subtype(pp)=jj;
                end
                if strcmp(RUNtypes{runtype}{jj},xxx{2});
                    subtype2(pp)=jj;
                end
                if strcmp(RUNtypes{runtype}{jj},xxx{3});
                    subtype3(pp)=jj;
                end
                if strcmp(RUNtypes{runtype}{jj},xxx{4});
                    subtype4(pp)=jj;
                end
            end
            if trialtype ==2
                precondAB_type(pp) = subtype(pp);
                precondCD_type(pp) = subtype2(pp);
            end
            
            
            fiD = fopen(['RUN7SITE.csv']);
            animaltextinput=textscan(fiD,'%s%s%s%s%s','Delimiter',',;');
            %NUMB = input(['which rat is this - ', animaltextinput{1}{2:end}','?:']);
            
            clear CSVN*
            
            for jj = 1:length(animaltextinput{1})
                CSVNumbers(jj) = str2double(animaltextinput{1}{jj}(3:4));
            end
            
            [xx NUMB] = find(CSVNumbers==animalIDnumber);
            
            RUNsites{1} = {'VTA','VS','OFC','BLA'};
           % RUNsites{7} = {'VTA','VS','OFC','BLA'};
            
            for ii = 1:2
                xxx{ii}=animaltextinput{ii+1}{NUMB};
            end
            
            for jj = 1:4
                if strcmp(RUNsites{1}{jj},xxx{1});
                    recording_1to8(pp)=jj;
                end
                if strcmp(RUNsites{1}{jj},xxx{2});
                    recording_9to16(pp)=jj;
                end
            end
            
            
        end
    end
end



nrnct=zeros(1,length(filename));

for pp=1:max(size(subtype))
    
    clear spike*
    clear poke*
    clear lfp*
    clear dat
    
    %%%%or files of interest
    cd(pathname);
    
    indat = load(filename{pp});
    e_stamps = indat(:,2)/1000;
    strobedvals = indat(:,1);
    
    trialstart = 20; %seconds pre-432
    trialstop = 60; %seconds pre-432
    
    UvLightOff = 420;  %the end of a trial is the offset of the first UV light!!
    
   nosepoke_strobed = e_stamps(strobedvals==402);
    trialend_strobed=e_stamps(strobedvals==UvLightOff);
%     if isempty(trialend_strobed)
%         strobedvals = strobedvals -512;
%         trialend_strobed=e_stamps(strobedvals==UvLightOff);
%         warning(['error with strobedvals in file, trying to shift values',filename{pp}])
        if isempty(nosepoke_strobed)
            strobedvals = strobedvals +1;
            trialend_strobed=e_stamps(strobedvals==UvLightOff);
            warning(['error with strobedvals in file, trying to shift values.',filename{pp}])
        end
%         if isempty(trialend_strobed)
%             warning(['error with strobedvals in file, this file needs individual help',filename{pp}])
%         end
%     end
    
    trialend_strobed = trialend_strobed-20; % this is a kludgy fix to shift
    
    %%%%%another terrible kludgy fix to recording an extra trial on animal
    %%%%%38 or 43 or 45 run 2 precond 2
    %     if (str2double(filename{pp}(3:4))==38 || (str2double(filename{pp}(3:4))==43) || (str2double(filename{pp}(3:4))==45) ) && trialtype == 2 && runtype ==2
    %         trialend_strobed = trialend_strobed(2:end);
    %     end
    %   the "zero time" to the cue start as opposed to the cue end
    
    
    %% find and load the channels with spikes and grab channel names
%     try
%         [t_stamps w_forms]=plx_info(filename{pp},1); %% note: samp. freq. = 40kHz
%     catch
%         [t_stamps w_forms]=plx_info(filename,1); %% note: samp. freq. = 40kHz
%     end
    
    %% split the spikes into trials on the basis of events
    
    clear what*
    ct(1:4)=0;
    whattrialisthis=zeros(size(trialend_strobed));
    if cuesortflag
        for tr = 1:length(trialend_strobed)
            if trialtype ==2
                trialstart2 = 2; %s pre lightoff
                trialstop2 = 2; %s post lightoff
                
                eventstamp_trial = strobedvals(trialend_strobed(tr)-trialstart2<e_stamps&e_stamps<trialend_strobed(tr)+trialstop2);
                eventstime_trial = e_stamps(trialend_strobed(tr)-trialstart2<e_stamps&e_stamps<trialend_strobed(tr)+trialstop2);
            else
                
                eventstamp_trial = strobedvals(trialend_strobed(tr)-trialstart<e_stamps&e_stamps<trialend_strobed(tr)+trialstop);
                eventstime_trial = e_stamps(trialend_strobed(tr)-trialstart<e_stamps&e_stamps<trialend_strobed(tr)+trialstop);
            end
            
            if runtype == 1 || runtype == 7
                
                if ~isempty(find(eventstamp_trial==424,1)) %Clicker
                    trialcue = 4;
                end
                if ~isempty(find(eventstamp_trial==422,1)) %WhiteNoise
                    trialcue = 3;
                end
                if ~isempty(find(eventstamp_trial==429,1)) %Siren
                    trialcue = 1;
                end
                if ~isempty(find(eventstamp_trial==425,1)) %Tone
                    trialcue = 2;
                end
                
                if trialtype==2
                    if trialcue==precondAB_type(pp)
                        st = 1;
                        
                        if tr==1
                            disp(['file#: ',num2str(pp),' starts with A-->B'])
                        end
                    elseif trialcue==precondCD_type(pp)
                        st = 2;
                        
                        if tr==1
                            disp(['file#: ',num2str(pp),' starts with C-->D'])
                        end
                        
                    else warning (['trial is neither AB or CD and therefore is likely mislabeled, file',num2str(pp),', trial ',num2str(tr)])
                    end
                    
                elseif trialtype>2
                    
                    if trialcue == subtype(pp)
                        st = 3;
                        
                    elseif trialcue == subtype2(pp)
                        st = 4;
                    elseif trialcue == subtype3(pp)
                        st = 1;
                    elseif trialcue == subtype4(pp)
                        st = 2;
                    else warning (['error--blank trial, file',num2str(pp),', trial ',num2str(tr)])
                    end
                end
                ct(st) = ct(st)+1
                
            elseif runtype == 2
                
                if ~isempty(find(eventstamp_trial==428,1)) && isempty(find(eventstamp_trial==426,1)) && isempty(find(eventstamp_trial==430,1)) %Alien (2)
                    trialcue = 1;
                end
                if ~isempty(find(eventstamp_trial==430,1)) && ~isempty(find(eventstamp_trial==428,1)) && isempty(find(eventstamp_trial==426,1)) %Chord (2,3)
                    trialcue = 2;
                end
                if ~isempty(find(eventstamp_trial==430,1)) && isempty(find(eventstamp_trial==426,1)) && isempty(find(eventstamp_trial==428,1)) %Sweep (3)
                    trialcue = 3;
                end
                if  ~isempty(find(eventstamp_trial==426,1)) && ~isempty(find(eventstamp_trial==428,1)) && isempty(find(eventstamp_trial==430,1)) %Wobble (1,2)
                    trialcue = 4;
                end
                
                if trialtype==2
                    if trialcue==precondAB_type(pp)
                        st = 1;
                        
                        if tr==1
                            disp(['file#: ',num2str(pp),' starts with A-->B'])
                        end
                    elseif trialcue==precondCD_type(pp)
                        st = 2;
                        
                        if tr==1
                            disp(['file#: ',num2str(pp),' starts with C-->D'])
                        end
                        
                    else warning (['trial is neither AB or CD and therefore is likely mislabeled, file',num2str(pp),', trial ',num2str(tr)])
                    end
                    
                elseif trialtype>2
                    
                    if trialcue == subtype(pp)
                        st = 3;
                        
                    elseif trialcue == subtype2(pp)
                        st = 4;
                    elseif trialcue == subtype3(pp)
                        st = 1;
                    elseif trialcue == subtype4(pp)
                        st = 2;
                    else warning (['error--blank trial, file',num2str(pp),', trial ',num2str(tr)])
                    end
                end
                
                ct(st) = ct(st)+1;
                
            elseif runtype ==3
                
                if ~isempty(find(eventstamp_trial==428,1)) && isempty(find(eventstamp_trial==426,1)) && isempty(find(eventstamp_trial==430,1)) %Train (2)
                    trialcue = 2;
                end
                if ~isempty(find(eventstamp_trial==430,1)) && ~isempty(find(eventstamp_trial==428,1)) && isempty(find(eventstamp_trial==426,1)) %Future (2,3)
                    trialcue = 1;
                end
                if ~isempty(find(eventstamp_trial==430,1)) && isempty(find(eventstamp_trial==426,1)) && isempty(find(eventstamp_trial==428,1)) %ToneRise (3)
                    trialcue = 3;
                end
                if  ~isempty(find(eventstamp_trial==426,1)) && ~isempty(find(eventstamp_trial==428,1)) && isempty(find(eventstamp_trial==430,1)) %PulsedTone (1,2)
                    trialcue = 4;
                end
                
                if trialtype==2
                    if trialcue==precondAB_type(pp)
                        st = 1;
                        if tr==1
                            disp(['file#: ',num2str(pp),'starts with A-->B'])
                        end
                    elseif trialcue==precondCD_type(pp)
                        st = 2;
                        if tr==1
                            disp(['file#: ',num2str(pp),'starts with C-->D'])
                        end
                    else warning (['trial is neither AB or CD and therefore is likely mislabeled, file',num2str(pp),', trial ',num2str(tr)])
                    end
                    
                elseif trialtype>2
                    
                    
                    if trialcue == subtype(pp)
                        st = 3;
                    elseif trialcue == subtype2(pp)
                        st = 4;
                    elseif trialcue == subtype3(pp)
                        st = 1;
                    elseif trialcue == subtype4(pp)
                        st = 2;
                    else warning(['error--blank trial, file',num2str(pp),', trial ',num2str(tr)])
                    end
                end
                ct(st) = ct(st)+1
                
            end

            try
                pokein(st).trials(ct(st)) = extractdatapt(e_stamps(strobedvals==402) , [trialend_strobed(tr)-trialstart trialend_strobed(tr)+trialstop],1);
                pokeout(st).trials(ct(st)) = extractdatapt(e_stamps(strobedvals==401), [trialend_strobed(tr)-trialstart trialend_strobed(tr)+trialstop],1);
            catch ME
                pokein(st).trials(ct(st)).times=[];
                
                pokeout(st).trials(ct(st)).times=[];
            end
            
                %% mark_which_trial_is_which for
   
        whattrialisthis(tr) = st;
        end
    
    end
    
    
    
    
    %% estimate how long / and how soon any animal was poking per cue
    
    try
        jjct=0;
        cueon = 40;
        cueoff = 50;
        % figure(pp+10);
        
        for ii = 3:1:size(pokein,2)
            
            for jj = 1:length(pokein(ii).trials)
                
                jjct=jjct+1;
                
                %%% POKE DURATION PER TRIAL
                
                
                pokduration{pp,ii}(jj) = 0;
                
                for kk = 1:length(find(pokein(ii).trials(jj).times<70))
                    
                    outindex = find(pokeout(ii).trials(jj).times>pokein(ii).trials(jj).times(kk),1,'first');
                    
                    if ~isempty(outindex)
                        
                        outtime = pokeout(ii).trials(jj).times(outindex);
                        
                        if kk<length(find(pokein(ii).trials(jj).times<70))
                            if outtime>pokein(ii).trials(jj).times(kk+1)%if there are 2 pokeins in a row
                                outtime = pokein(ii).trials(jj).times(kk)+.0001;
                            end
                        end
                        
                        inptime = pokein(ii).trials(jj).times(kk);
                        
                        if inptime<cueon && outtime>cueoff
                            pokduration{pp,ii}(jj) = cueoff-cueon;
                        elseif inptime<cueon && outtime>cueon && outtime<cueoff
                            pokduration{pp,ii}(jj) = pokduration{pp,ii}(jj)+ outtime-cueon;
                        elseif inptime>cueon && inptime<cueoff && outtime>cueoff
                            pokduration{pp,ii}(jj) = pokduration{pp,ii}(jj)+ cueoff - inptime;
                        elseif inptime>cueon && inptime<cueoff && outtime<cueoff && outtime>cueon
                            pokduration{pp,ii}(jj) = pokduration{pp,ii}(jj)+outtime-inptime;
                        end
                        
                    end
                end
                
            end
            
            meanduration(ii,pp) = nanmean(pokduration{pp,ii});
            stdduration(ii,pp) = nanstd(pokduration{pp,ii});
            
        end
        
    catch ME2
    end
    
    %%%get correct variable names    
    % for pokes and whats
    neural_var_names=whos('poke*');
    for vv = 1:length(neural_var_names)
        assignin('base',[neural_var_names(vv).name,'_',filename{pp}(1:4)]...
            ,[])
        
        evalin('base',[neural_var_names(vv).name,'_',filename{pp}(1:4),'=',neural_var_names(vv).name])
        clear(evalin('base','neural_var_names(vv).name'))
    end
    
    neural_var_names=whos('what*');
    for vv = 1:length(neural_var_names)
        assignin('base',[neural_var_names(vv).name,'_',filename{pp}(1:4)]...
            ,[])
        
        evalin('base',[neural_var_names(vv).name,'_',filename{pp}(1:4),'=',neural_var_names(vv).name])
        clear(evalin('base','neural_var_names(vv).name'))
    end
    
    
    
    
    %% save data appropriately
    try
        save([filename{pp}(1:end-4),'_BEH_and_trialindex_',num2str(trialtype),'.mat'],'poke*','what*')
    catch ME
        try
            save([filename{pp}(1:end-4),'_justBEH_',num2str(trialtype),'.mat'],'poke*')
        catch ME
            save([filename(1:end-4),'_justBEH_',num2str(trialtype),'.mat'],'poke*')
        end
    end
end
