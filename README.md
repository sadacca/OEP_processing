# OEP_processing #
initial data processing scripts and functions for wrangling open-ephys data formats to formats usable for a range of spike sorting solutions (e.g. *.dat for klustasuite or phy), and batch scripts for calling both data formatting functions, pre-processing this data (spike detection, waveform clustering), and then simple plotting and analysis tools.  This set includes template 'parameters' and 'probe'files required for running klustasuite and/or phy and a small handful of dependent functions developed elsewhere for ease of use.

---

### currently includes:

* matlab code to view continuous data before pre-processing with spike detection and clustering

* matlab code to convert .continuous and .kwik files to .dat files (including one dependent function for reading open-ephys headers taken from open-ephys/analysis-tools)

* tetrode-based and 'probe' file for sorting 8-tetrode data (with layout according to open-ephys standard 32ch EIB correctly and 'backwards') for use with spikedetekt and klustakwik

* 16ch-based probe file for a single-shank 16ch silicone probe for use with spikedetekt and klustakwik

* parameters template file with parameters for spikedetekt and klustakwik

* post-clustering spike-time and waveform shape extraction from klustaviewa/klustakwik .kwik and .kwx

* batch file for pre-processing, detecting spikes, and clustering 'raw' data from a handful of directories with a single click 

* event extraction from open-ephys *.event files and MED-PC 'text' files

