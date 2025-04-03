# Particle-filter-coupled-model
The PF_main.m script runs a sensitivity-informed Particle Filter to assimilate reflectance data into a coupled crop-radiative transfer model using the DSSAT-CROPGRO-Tomato crop model the RTMo module of the SCOPE model (RTMo accounts for the radiative transfer for radiation in the optical domain). The Plot_PF_results.m script plots the particle filter results.
The software tools applied in this script are:
-	MATLAB R2023b
-	SCOPE 2.0
-	DSSAT 4.7
  
•	Note that older or newer versions are probably applicable for running this code but might require some code adaptations.

## General notes
- All the relevant simulation details (e.g., number of particles, which coupling relationship to use, etc.) are defined inside the DefineSimulationDetails(). On the other hand, the function SimulationInitialization() define properties constant for the simulated season and data file names which are not supposed to be changed unless you are simulating a different case study.
- In the Plot_PF_results.m, you should assign the name of directory containing the PF results you want to plot to the variable ‘dir_name’ at the beginning of the script. Note that the files containing the results are created during the PF_main script inside the PF_results directory.

## Instructions to make the script compatible with your machine
- Defining file paths 
  -	In the function DefineSimulationDetails() (located the Input folder), the paths where the downloaded DSSAT and SCOPE are located should be specified in the corresponding variables. Moreover, the full paths of DSSAT’s cultivar and           ecotype should be defined in their corresponding variables.
  -	DSSAT’s .exe file name should be defined in the function DefineSimulationDetails() according to the DSSAT version installed on your machine.
- DSSAT input files
  - The DSSAT input files containing the inputs and parameters required for the simulation (weather, soil, and genotype properties and season and batch files) are located in the DSSAT Input Files folder. You should copy the files provided     to DSSAT directories as follows:
    * DSSBatch1.V47 – to the main directory of DSSAT
    * HAVA1901.SNX – to the Seasonal directory
    *	HAVA1901.WTH – to the Weather directory
    *	TMGRO047.CUL and TMGRO047.ECO – to the Genotype directory
      
      **	Note that for these two files, you can only copy the line starting with TM0011 to the corresponding files you got after downloading DSSAT. Copying the files provided here might overrun the existing ones.
    *	SOIL.SOL – to the Soil directory
      
      **	Note that you can only copy the soil properties of the soil called tectec00001 to corresponding file you got after downloading DSSAT. Copying the file provided here might overrun the existing one.
- SCOPE modification
  - In the setoptions file located in the input directory, set the number next to the ‘vreify’ option to 0.
  -	In the main SCOPE script called SCOPE.m, disable the restoredefaultpath command at the beginning of the script (either by deleting it or make it a comment)
  -	Inside the function create_output_files_binary() located in src\IO and called on section 13 of the SCOPE script (‘create output files’), the variable ‘outdir_name’ should be assigned with the string ‘DSSAT_coupling’, rather than its       default value. This will make SCOPE save the simulation results in the same directory each run rather than save it in a new directory each time. This constant output directory is reached during the particle filter run. Note that you        don’t must use the string ‘DSSAT_coupling’, but if you choose a different name, you need to update this line in the DefineSimulationDetails() function called from the PF_main script.

## Potential reason for running errors
-	The mat_run_PlantGro function (and the other function used to read DSSAT output files), uses a string indicating the pattern (parameter names and spacings) employed in the output files for version 4.7 of DSSAT. Since in other versions of DSSAT the number of parameters might change, the string used to define this pattern might need to be modified.
-	Note if in other SCOPE versions, there is no change in directory and file names (e.g. ‘input’ ,’output’,’ set_parameter_filenames.csv’, etc).

