# OEP_processing #
initial data processing scripts and functions for wrangling open-ephys data formats to formats usable for a range of spike sorting solutions (e.g. *.dat for klustasuite or phy), and batch scripts for calling both data formatting functions, pre-processing this data (spike detection, waveform clustering), and then simple plotting and analysis tools.  This set includes template 'parameters' and 'probe'files required for running klustasuite and/or phy and a small handful of dependent functions developed elsewhere for ease of use.

---

### currently includes:

* matlab code to view continuous data before pre-processing with spike detection and clustering

* matlab code to convert .continuous and .kwik files to .dat files (including one dependent function for reading open-ephys headers shamelessly taken from open-ephys/analysis-tools) and do some light pre-processing including referencing to a common-average reference and/or large event deletion following highpass filtering to mitigate large acute sources of noise

* 4 tetrode-based probe files for sorting 1 or 8-tetrode data (with 32ch layout according to new lab standard 32ch EIBs in addition to open-ephys standard 32ch EIB correctly and 'backwards') for use with spikedetekt and klustakwik

* 16ch-based probe file for a single-shank 16ch silicone probe for use with spikedetekt and klustakwik

* parameters template file with parameters for both the new and old 'klusta/phy' versions of spikedetekt and klustakwik

* post-clustering spike-time and waveform shape extraction from klustaviewa/klustakwik .kwik and .kwx

* batch file for pre-processing, detecting spikes, and clustering 'raw' data from a handful of directories with a single click 

* additional batch files for moving or deleting extranious data (.AUX files) across all subdirectories

* event extraction from open-ephys *.event files, MED-PC 'text' files, and lab standard *.tst files

