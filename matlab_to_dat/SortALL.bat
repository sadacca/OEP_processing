# a batch script to be run from a 'pending'
# analysis directory in order to do three things:
# copy files from one directory to another
# [1] copy a file to all sub directories 
# e.g. params.prm and probe.prb
# [2] run spikedetekt and klustakwik
# on data in all sub directories using .prm & .prb
# and once analysis is complete, copy to a new directory

# #copy params   : UNTESTED
# #convert files : UNTESTED
# #cluster data  : UNTESTED 
# #move finished : UNTESTED


# copy files to all sub directories from main directory

@echo off
    Setlocal EnableDelayedExpansion
    cls
    set currentDirectory=%CD%
    FOR /D %%g IN ("*") DO (
        Pushd %CD%\%%g
        FOR /D %%f IN ("*") DO (
            copy "%currentDirectory%\params.prm" "%%~ff"
	    copy "%currentDirectory%\32chTetrodes.prb" "%%~ff"
        )
    Popd
    )
pause

# convert all datafiles from OEP or KWIK to .dat via MATLAB
# 3 required functions: 2x "oep_to_*" and 1x "load_open"
# all in matlab path.  Requires matlab (tested v2014a), octave 4.0 may work

@echo off
    Setlocal EnableDelayedExpansion
    cls
    set currentDirectory=%CD%
    FOR /D %%g IN ("*") DO (
        Pushd %CD%\%%g
        FOR /D %%f IN ("*") DO (
            if exist "*.kwik" (
            	matlab -nojvm -nodisplay -nosplash -r "OEPKiwk_to_dat"
	    )
            if exist "*.continuous" (
            	matlab -nojvm -nodisplay -nosplash -r "OEPcont_to_dat"
	    )
        )
    Popd
    )
pause


# detect spikes from the continuous data in the *.dat file with spikedetekt
# and cluster data with klustakwik on the basis of the params file and prb file
# which were copied in the first phase of this batch file
# this, of course requires klustaviewa and all the python 2.7 accessories
# will eventually be converted to phy when phy is a more mature platform

@echo off
    Setlocal EnableDelayedExpansion
    cls
    set currentDirectory=%CD%
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
pause