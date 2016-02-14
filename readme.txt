Halftoning evaluator
-------------------------------
The Halftoning evaluator is a simulation tool for halftoning algorithm designers and academic researchers. The tool is designed to provide an effective benchmark for the sensitivity of the examined halftoning algorithms to distortions that could happen during the printing process. In fact, the simulator establishes the foundation for many types of simulations which can evaluate halftoning algorithms. The Simulator is implemented in MATLAB which might be the most convenient way to test halftoning algorithms.


System Requirements
-------------------------------

CPU: Intel i5 or equivalent
RAM: 8 GB, (16 GB or above recommended)
MATLAB R2013a or a newer version with image processing and signal processing toolboxes.


Installation Instructions
-------------------------------
 
Extract the ZIP file and put the halftoning evaluator content in a directory.
Use MATLAB “Set path” to add the chosen directory to the list.
Set the current executing directory in MATLAB to the chosen directory.
Optional: download the “Halftoning toolbox for MATLAB” and use MATLAB “Set Path” to add this toolbox to the list.


How to use?
-------------------------------
 
Executing:

The main.m is the entry point. In order to execute the simulator, run main.m.
In this file you may define your test details, which sensitivity to test and under which parameters.


Customize Dataset:

The Simulator has a default dataset. In case you want to customize it, locate your own files in the dedicated directories:
Natural images are located in “Images” directory
Flat test image are located in “TI” directory


Customize Algorithms list: 

The Simulator contains a default algorithms list, including algorithms from the “Halftoning toolbox for MATLAB”.  In order to customize this list, define the algorithms you wish to execute in get_algorithms.m file. 


Customize Executing Parameters:

Review get_default_config.m file to see the default values for the various parameters.
You may want to modify a few of them according to your needs. 


Source code
-------------------------------

https://github.com/shnizelsh/halftoning-evaluator/


Author:
 -------------------------------

It was created by Ariel Shmerling under supervision of Prof. Yacov Hel-Or and Dr. Carl Staelin, as part of the fulfillment of the requirements for the Degree of Master of Science (M.Sc.) Research Track in Computer Science school of IDC Herzliya 




