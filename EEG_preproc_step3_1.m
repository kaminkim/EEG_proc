%  EEG preprocessing  step3_1: auto-reject trials 
%
dirs.pj = '/Volumes/HD/project_dir/';
dirs.in = [dirs.pj 'data/preprocessed/phase2_long_ep/step2_ep/'];
dirs.out = [dirs.pj 'data/preprocessed/phase2_long_ep/step3_clean/'];

% set up subjects and processing steps
subjects = [1:10]; 

% load eeglab 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for iSub = 1 : length(subjects)     
     if subjects(iSub) < 10
        subnum = ['s0', num2str(subjects(iSub))];
    else
        subnum = ['s' num2str(subjects(iSub))];
    end     
    filename.in = ['phase2long_' subnum '_ep.set'];
    filename.out = ['auto_trial_rejection_' subnum '.mat'];
   
    EEG = pop_loadset( 'filename', filename.in , 'filepath', dirs.in);
    
    % auto find trials 
    [EEG2, ~, ~, ~] = pop_jointprob(EEG, 1, [1:64], 5, 5, 1, 0, 1);
    btrialvec.jointprob = EEG2.reject.rejjp; 

    EEG3 = eeg_rejsuperpose(EEG2, 1, 1, 1, 1, 1, 1, 1, 1); % include all rejection methods
    btrialvec.rejsuperpose =  EEG3.reject.rejglobal; 
    rejectionfield = EEG3.reject; 

    save (fullfile(dirs.out, filename.out), 'btrialvec', 'rejectionfield');  
    clear EEG*
end 
