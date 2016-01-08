REM ### a batch script to be run from a 'pending'
REM ### analysis directory in order to do four things:
REM ### [1] copy prm and prb files to all sub directories 
REM ### [2] convert files from native format to dat files
REM ### [3] run spikedetekt and klustakwik on dat files using .prm & .prb
REM ### [4] copy clustered data to a new, finalized directory

REM ### #copy params   : TESTED 010816
REM ### #convert files : UNTESTED
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
		
timeout 10

REM ## convert all datafiles from OEP or KWIK to .dat via MATLAB
REM ## 3 required functions: 2x "oep_to_*" and 1x "load_open"
REM ## all in matlab path.  Requires matlab (tested v2014a), octave 4.0 may work


REM # for each directory 
REM # (where %%G becomes each dirctory name)
	
FOR /D %%G IN ("*") DO (

	REM # jump into the sub directory \%%G
	Pushd %CD%\%%G
 
	REM # run the appropriate matlab script for file type in sub directory
	if exist "*.kwik" (
			@echo there's a kwik file, matlabbing
			matlab -nojvm -nodisplay -nosplash -r "OEPKiwk_to_dat"
	)
		if exist "*.continuous" (
			@echo there are continuous files, matlabbing
			matlab -nojvm -nodisplay -nosplash -r "OEPcont_to_dat"
	)

	REM # return to the main directory
	Popd
)

timeout 10


REM ## detect spikes from the continuous data in the *.dat file with spikedetekt
REM ## and cluster data with klustakwik on the basis of the params file and prb file
REM ## which were copied in the first phase of this batch file
REM ## this, of course requires klustaviewa and all the python 2.7 accessories
REM ## will eventually be converted to phy when phy is a more mature platform


FOR /D %%g IN ("*") DO (
	Pushd %CD%\%%g
	FOR /D %%f IN ("*") DO (
		IF exist "*.dat" (
			klusta params.prm
	
		) 
		IF NOT exist "*.dat" (
			echo ("there is not a data file -- skipping")
			)
		)
	
	Popd
)

timeout 10

REM # move all files to a completed analysis folder

		REM # for each directory 
		REM # (where %%G becomes each dirctory name)
        
		FOR /D %%G IN ("*") DO (
		
		    REM # copy the pertinant files and say that it's done
        
			copy "%currentDirectory%\params.prm" "%%G"
			copy "%currentDirectory%\32chTetrodes.prb" "%%G"
			@echo %%G copying completed
        )
		