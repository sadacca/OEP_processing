# OEP_processing
initial data processing scripts and functions for wrangling open-ephys data formats to formats usable for a range of spike sorting solutions (e.g. *.dat for klustasuite or phy), and batch scripts for calling both data formatting functions and then pre-processing this data (spike detection, waveform clustering), including template 'parameters' and 'probe'files required for running klustasuite and/or phy 

currently includes:

- matlab code to convert .continuous and .kwik files to .dat files (including one dependent function for reading open-ephys headers taken from open-ephys/analysis-tools)

- tetrode-based 'probe' file for sorting 8-tetrode date (with layout according to open-ephys standard 32ch EIB)

- 16ch-based probe file for a single-shank 16ch silicone probe

- parameters template file with parameters for spikedetekt and klustakwik

