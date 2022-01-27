# eegproc
step-by-step preprocessing of scalp eeg data 

# Requirements
- [eeglab](https://sccn.ucsd.edu/eeglab/) - all steps except for step3_2 uses eeglab
- [fieldtrip](https://www.fieldtriptoolbox.org/) - used in step3_2 
- Note: some functions in the two toolboxes conflict 
- To avoid conflict issues: 
- Have only one of the toolboxes in the path at any time 
  (Use *restoredefaultpath* to remove paths and add a toolbox fresh)
