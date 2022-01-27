%%  preprocessing  step2: epoch data 
% KK April 2019


%% add path to eeglab 

%%
clear all; 

dirs.pj = '/Volumes/HD/project_dir/';
dirs.in = [dirs.pj 'data/preprocessed/phase2_long_ep/step1_cont/'];
dirs.out = [dirs.pj 'data/preprocessed/phase2_long_ep/step2_ep/'];

% set up subjects and processing steps
subjects = [1:10]; 
epoch_win = [-1 4]; % in second
event_codes = {'11' '12' '13' '14' '15' '16'}; 
%% load and epoch data 
% load eeglab 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for iSub = 1 : length(subjects)     
     if subjects(iSub) < 10
        subnum = ['s0', num2str(subjects(iSub))];
    else
        subnum = ['s' num2str(subjects(iSub))];
    end   
    filename.in = ['phase2long_' subnum '_ds_ref_filt.set'];
   
    disp(['loading data from subject number ' num2str(subjects(iSub)) '...']);
  
    EEG = pop_loadset( 'filename', filename.in , 'filepath', dirs.in);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, event_codes,...
       epoch_win, 'newname', 'epochs', 'epochinfo', 'yes');
    
    EEG = pop_rmbase( EEG, [-500  0]);
    EEG = pop_saveset( EEG, 'filename', ['phase2long_' subnum '_ep.set'], 'filepath', dirs.out);
    
    clear EEG ;
end 