REM ### a batch script to be run from a 'pending'
REM ### analysis directory in order to do four things:
REM ### [1] copy prm and prb files to all sub directories 
REM ### [2] convert files from native format to dat files
REM ### [3] run spikedetekt and klustakwik on dat files using .prm & .prb
REM ### [4] copy clustered data to a new, finalized directory

REM ### #copy params   : TESTED 010816
REM ### #convert files : TESTED CONT 010816
REM ### #cluster data  : UNTESTED 
REM ### #move finished : UNTESTED

REM ## set up the initial environment

	REM # don't display the script unless told to
	@echo off 

	REM # don't expand the vars 'till execution
	Setlocal EnableDelayedExpansion 
    
	REM # clean the display
	cls  
	
	REM # establish the main directory
	set currentDirectory=%CD%

REM ## copy files to all sub directories from main directory
        
		REM # for each directory 
		REM # (where %%G becomes each dirctory name)
        
		FOR /D %%G IN ("*") DO (
		
		    REM # copy the pertinant files and say that it's done
        
			copy "%currentDirectory%\params.prm" "%%G"
			copy "%currentDirectory%\OEP_32_Tetrodes.prb" "%%G"
			@echo %%G copying completed
        )
		
timeout 3

REM ## convert all datafiles from OEP or KWIK to .dat via MATLAB
REM ## 3 required functions: 2x "oep_to_*" and 1x "load_open"
REM ## all in matlab path.  Requires matlab (tested v2014a), octave 4.0 may work


REM # for each directory 
REM # (where %%G becomes each dirctory name)
	FOR /D %%G IN ("*") DO (

	REM # jump into the sub directory \%%G
	Pushd %CD%\%%G
	
	REM # if you've got your datafile, don't bother to matlab
	if exist *.dat (
		GOTO whileEnd
		)
		
	REM # run the appropriate matlab script for file type in sub directory
	if exist "*.kwik" (
			@echo there's a kwik file, matlabbing
			C:\"Program Files"\MATLAB\R2014a\bin\matlab.exe -nojvm -nodesktop -nosplash -nodisplay -r "OEPKiwk_to_dat"
	)
		if exist "*.continuous" (
			@echo there are continuous files, matlabbing
			C:\"Program Files"\MATLAB\R2014a\bin\matlab.exe -nojvm -nodesktop -nosplash -nodisplay -r "OEPcont_to_dat"
	)
	REM # need to fudge while loops in batch scripting
	REM # to wait for file creation before iterating loops
	REM # lest you overload computer's memory w/ matlab instances
	
	REM # create tag for whileLoopStart
	:whileStart
	
	REM # if you've got your datafile, end this crazy train
	if exist *.dat (
		GOTO whileEnd
		)
		
	REM # otherwise, wait for a bit	and return to the beginning
	timeout 45
	GOTO whileStart
		
	REM # if we're done (whileEnd)
	:whileEnd
	REM # return to the main directory
	Popd
)

timeout 3

REM ## detect spikes from the continuous data in the *.dat file with spikedetekt
REM ## and cluster data with klustakwik on the basis of the params file and prb file
REM ## which were copied in the first phase of this batch file
REM ## this, of course requires klustaviewa and all the python 2.7 accessories
REM ## will eventually be converted to phy when phy is a more mature platform


FOR /D %%g IN ("*") DO (
	Pushd %CD%\%%g
	FOR /D %%f IN ("*") DO (
		IF exist "*.dat" (
			REM # don't bother to sort if you've got sorted data
			IF EXIST *.kwx (
			GOTO whileEnd2
			)
		
		REM # if no sorted data, sort the data and wait for a result
			klusta params.prm
		
	REM # Again, need to fudge while loops in batch scripting
	REM # to wait for file creation before iterating loops
	REM # lest you overload computer's memory w/ klusta instances
	
	REM # create tag for whileLoopStart
	:whileStart2
	
	REM # if you've got your datafile, end this crazy train
	if exist *.kwx (
		GOTO whileEnd
		)
		
	REM # otherwise, wait for a while and return to the beginning
	timeout 180
	GOTO whileStart2
	
	
		)
		
		IF NOT exist "*.dat" (
			echo ("there is not a data file -- skipping")
			)
		)
		
	REM # finished with this directory, on to the next
	:whileEnd2
	Popd
)

timeout 10

REM # move all files to a completed analysis folder
