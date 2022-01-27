%  EEG preprocessing  step3_3: interpolate bad channels 
%  eeglab 
clear all;
dirs.pj = '/Volumes/HD/project_dir/';
dirs.in_eeg = [dirs.pj 'data/preprocessed/phase2_long_ep/step2_ep/'];
dirs.in_rejinfo = [dirs.pj 'data/preprocessed/phase2_long_ep/step3_clean/'];
dirs.out = [dirs.pj 'data/preprocessed/phase2_long_ep/step3_clean/'];

subj = 's01'; 
%%
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

filename.in = ['phase2long_' subj '_ep.set']; 
EEG = pop_loadset( 'filename', filename.in , 'filepath', dirs.in_eeg);
eeglab redraw; 

load(fullfile(dirs.in_rejinfo, [subj '_data_cleaning.mat'])); 
EEG_int = eeg_interp(EEG, ft_bchans, 'spherical'); 

pop_eegplot(EEG, 1, 0, 0); 
pop_eegplot(EEG_int, 1, 0, 0); pause; 

intres = questdlg('Approve interpolation?', 'Check', 'Yes', 'No', 'Yes'); 
if strcmp(intres, 'Yes')
   clear EEG; 
   EEG = EEG_int; 
   EEG = pop_saveset( EEG, 'filename', ['phase2long_' subj '_ep_interp.set'], 'filepath', dirs.out);
end 