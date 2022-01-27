%% EEG preprocessing  step4:clean data 
% trial auto & manual rejection before this 
%% ==========================
dirs.pj = '/Volumes/HD/project_dir/';

dirs.in = [dirs.pj 'data/preprocessed/phase2_long_ep/step3_clean/'];
dirs.out = [dirs.pj 'data/preprocessed/phase2_long_ep/step4_ica/'];

% set up subjects and processing steps
subjects = [1:10]; 

%% load and epoch data 
% load eeglab 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for iSub = 1 %ad: length(subjects)     
     if subjects(iSub) < 10
        subnum = ['s0', num2str(subjects(iSub))];
    else
        subnum = ['s' num2str(subjects(iSub))];
    end   
    filename.in = ['phase2long_' subnum '_ep_interp.set']; 
    filename.out = ['phase2long_' subnum '_ep_interp_ica.set'];
   
    EEG = pop_loadset( 'filename', filename.in , 'filepath', dirs.in);
        
    EEG = pop_runica(EEG,'icatype', 'runica', 'chanind',[1:70]);

    % Save the data
    EEG = pop_saveset(EEG, 'filename', filename.out, 'filepath', dirs.out); 
    clear EEG
end 