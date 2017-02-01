%function []=collected_trial_index()
%take output of Convert_tst2mat_schoenSPC_justBEH
%and add together files for same rat (presumably from same day)
%for specific use with SPC probe tests where multiple tst files are made
%for each rat(3-to-4)  these indicies will be for use with OEP timestamps
%which are generated for each time a cue comes on -- can be keyed to use
%data from these indicies. 

filenames = what;
for ii = 1:length(filenames.mat)
    animalIDindex(ii) = str2num(filenames.mat{ii}(3:4));
    
end

uniqueIDindex = unique(animalIDindex);

for ii = 1:length(uniqueIDindex)
    clear full*
    clear what*
    
    fulltrialindex = [];

    files = find(animalIDindex==uniqueIDindex(ii));
    
    for jj = 1:length(files)
        load(filenames.mat{files(jj)});
        whosefilename=whos('what*');
        fulltrialindex = [fulltrialindex;eval(whosefilename.name)];
    end
    

    neural_var_names=whos('full*');
    
    vv=1;
        assignin('base',[neural_var_names(vv).name,'_',num2str(uniqueIDindex(ii))]...
            ,[])
        
        evalin('base',[neural_var_names(vv).name,'_',num2str(uniqueIDindex(ii)),'=',neural_var_names(vv).name])
        
        clear(evalin('base','neural_var_names(vv).name'))
    
    
    save(['full_trialindex_animalID',num2str(uniqueIDindex(ii)),'.mat'],'full*')

end

