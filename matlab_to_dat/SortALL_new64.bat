REM ### a batch script to be run from a 'pending'
REM ### analysis directory in order to do four things:
REM ### [1] copy prm and prb files to all sub directories 
REM ### [2] convert files from native format to dat files
REM ### [3] run spikedetekt and klustakwik on dat files using .prm & .prb
REM ### [4] copy clustered data to a new, finalized directory

REM ### #copy params   : TESTED 010816
REM ### #convert files : TESTED CONT 010816
REM ### #cluster data  : TESTED 010816 

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
        
			copy "%currentDirectory%\newparams1.prm" "%%G"
			copy "%currentDirectory%\newparams2.prm" "%%G"
			copy "%currentDirectory%\BS_32_tetrodes.prb" "%%G"
			@echo %%G copying completed
			
			cd %CD%
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
	if not exist "*.dat" (
		
		
	REM # run the appropriate matlab script for file type in sub directory

		if exist "*.continuous" (
			@echo there are continuous files, matlabbing
			C:\"Program Files"\MATLAB\R2014a\bin\matlab.exe -nojvm -nodesktop -nosplash -nodisplay -r "OEPcont_to_dat_AVGREF"
	)
	
	REM # need to fudge while loops in batch scripting
	REM # to wait for file creation before iterating loops
	REM # lest you overload computer's memory w/ matlab instances
	)
	
	@echo %%G
	
	if not exist "*.dat" call :whileLoopStart
	REM # create tag for whileLoopStart
    @echo directory complete
	REM # return to the main directory
	Popd
)

	
	
timeout 3

REM ## detect spikes from the continuous data in the *.dat file with spikedetekt
REM ## and cluster data with klustakwik on the basis of the params file and prb file
REM ## which were copied in the first phase of this batch file
REM ## this, of course requires klustaviewa and all the python 2.7 accessories
REM ## will eventually be converted to phy when phy is a more mature platform

activate klusta

FOR /D %%g IN ("*") DO (
	Pushd %CD%\%%g
	
		IF exist "*.dat" (
			REM # don't bother to sort if you've got sorted data
			
			
			klusta --overwrite newparams1.prm
		
		)

	
	REM # if you've got your datafile, end this crazy train
	REM if NOT exist *.kwx call :whileLoopStart2

	Popd
)

FOR /D %%g IN ("*") DO (
	Pushd %CD%\%%g
	
		IF exist "*.dat" (
			REM # don't bother to sort if you've got sorted data
			
			klusta --overwrite params2.prm
		
		)

	
	REM # if you've got your datafile, end this crazy train
	REM if NOT exist *.kwx call :whileLoopStart2

	Popd
)

timeout 10
deactivate
exit


	REM # move all files to a completed analysis folder
	:whileLoopStart
	
	REM # if you've got your datafile, end this crazy train
    if exist "*.dat" GOTO :breakLoop
	
	REM # otherwise, wait for a bit	and return to the beginning
	timeout 60
	@echo waiting for file production
	
	GOTO :whileLoopStart
	@echo done waiting gettin ready to exit
	REM # if we're done (whileEnd)
	:breakLoop
	exit /b
	
	
	REM # move all files to a completed analysis folder
	:whileLoopStart2
	
	REM # if you've got your datafile, end this crazy train
    if exist "*.kwx" GOTO :breakLoop2
	
	REM # otherwise, wait for a bit	and return to the beginning
	timeout 60
	@echo waiting for file production
	
	GOTO :whileLoopStart2
	@echo done waiting gettin ready to exit
	REM # if we're done (whileEnd)
	:breakLoop2
	exit /b