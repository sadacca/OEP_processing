### a batch script to be run from a 'pending'
### analysis directory in order to do four things:
### [1] copy prm and prb files to all sub directories 
### [2] convert files from native format to dat files
### [3] run spikedetekt and klustakwik on dat files using .prm & .prb
### [4] copy clustered data to a new, finalized directory

### #copy params   : TESTED 010816
### #convert files : UNTESTED
### #cluster data  : UNTESTED 
### #move finished : UNTESTED

## set up the initial environment

	# don't display the script unless told to
	@echo off 

	# don't expand the vars 'till execution
	Setlocal EnableDelayedExpansion 
    
	# clean the display
	cls  
	
	# establish the main directory
	set currentDirectory=%CD%

## copy files to all sub directories from main directory
        
		# for each directory 
		# (where %%G becomes each dirctory name)
        
		FOR /D %%G IN ("*") DO (
		
		    # copy the pertinant files and say that it's done
        
			copy "%currentDirectory%\params.prm" "%%G"
			copy "%currentDirectory%\32chTetrodes.prb" "%%G"
			@echo %%G copying completed
        )
		
SLEEP 10

## convert all datafiles from OEP or KWIK to .dat via MATLAB
## 3 required functions: 2x "oep_to_*" and 1x "load_open"
## all in matlab path.  Requires matlab (tested v2014a), octave 4.0 may work


# for each directory 
# (where %%G becomes each dirctory name)
	
FOR /D %%G IN ("*") DO (

	# jump into the sub directory \%%G
	Pushd %CD%\%%G
 
	# run the appropriate matlab script for file type in sub directory
	if exist "*.kwik" (
			@echo there's a kwik file, matlabbing
			matlab -nojvm -nodisplay -nosplash -r "OEPKiwk_to_dat"
	)
		if exist "*.continuous" (
			@echo there are continuous files, matlabbing
			matlab -nojvm -nodisplay -nosplash -r "OEPcont_to_dat"
	)

	# return to the main directory
	Popd
)

SLEEP 10


## detect spikes from the continuous data in the *.dat file with spikedetekt
## and cluster data with klustakwik on the basis of the params file and prb file
## which were copied in the first phase of this batch file
## this, of course requires klustaviewa and all the python 2.7 accessories
## will eventually be converted to phy when phy is a more mature platform


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

SLEEP 10

# move all files to a completed analysis folder

		# for each directory 
		# (where %%G becomes each dirctory name)
        
		FOR /D %%G IN ("*") DO (
		
		    # copy the pertinant files and say that it's done
        
			copy "%currentDirectory%\params.prm" "%%G"
			copy "%currentDirectory%\32chTetrodes.prb" "%%G"
			@echo %%G copying completed
        )
		