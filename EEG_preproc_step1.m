%% EEG preprocessing 
% KK April 2019

%% preprocessing step1
% continuous data - rereference, downs

%% add path to eeglab 

%%
clear all; 

dirs.pj = '/Volumes/HD/project_dir/';
dirs.raw = [dirs.pj 'data/raw/'];
dirs.preproc = [dirs.pj 'data/preprocessed/phase2_long_ep/'];
dirs.save = [dirs.pj 'data/preprocessed/phase2_long_ep/step1_cont/'];

% set up subjects and processing steps
subjects = [1:10]; 
runsteps = {'ds', 'ref', 'filt'}; %
CheckBeforeSaving = 0; 

%% load and convert data 
% load eeglab 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for iSub = 1 : length(subjects) 
    % naming conventions 
    
    if subjects(iSub) < 10
        subnum = ['s0', num2str(subjects(iSub))];
    else
        subnum = ['s' num2str(subjects(iSub))];
    end   
   
    disp(['loading data from subject number ' num2str(subjects(iSub)) '...']);

    if exist(fullfile(dirs.raw, ['/' subnum '/' 'phase2_' subnum '.set'])) ==  2
       filename.in = ['phase2_' subnum '.set'];       
       EEG = pop_loadset('filename', filename.in, 'filepath', dirs.raw); 
    else
       filename.in = ['phase2_' subnum '.bdf'];
       % import bdf data without referencing 
       EEG = pop_biosig(fullfile([dirs.raw '/' subnum '/' ], filename.in)); 
       EEG = eeg_checkset( EEG );
       if CheckBeforeSaving; pop_eegplot(EEG, 1, 0, 0); pause; end 
       EEG = pop_saveset(EEG, 'filename', ['phase2long_' subnum '.set'] ,'filepath', dirs.raw);
    end  

    for iStep = 1: length(runsteps) 

        % downsample 
        if strcmp(runsteps(iStep), 'ds')

            filename.out = [EEG.filename(1:strfind(EEG.filename, '.')-1) '_ds.set'];
            EEG = pop_resample(EEG, 200);        
            if ~isequal(EEG.srate, 200)
                EEG = pop_resample(EEG, 200);
            end
            EEG = eeg_checkset( EEG );
            if CheckBeforeSaving; pop_eegplot(EEG, 1, 0, 0); pause; end 
            EEG.chanlocs = readlocs([dirs.pj 'codes/bioSemi64.ced']); % label channels before saving      
            EEG = pop_saveset(EEG, 'filename', filename.out ,'filepath', dirs.save);

        elseif strcmp(runsteps(iStep), 'ref')

            filename.out = [EEG.filename(1:strfind(EEG.filename, '.')-1) '_ref.set'];         
            EEG = pop_reref(EEG, [65 66], 'keepref', 'on');
            EEG = eeg_checkset( EEG );
            if CheckBeforeSaving; pop_eegplot(EEG, 1, 0, 0); pause; end 
            EEG = pop_saveset(EEG, 'filename', filename.out ,'filepath', dirs.save);

         elseif strcmp(runsteps(iStep), 'filt')

            filename.out = [EEG.filename(1:strfind(EEG.filename, '.')-1) '_filt.set'];          
            % Filter 
            EEG = pop_eegfiltnew( EEG, 0.1, 50);
            EEG = eeg_checkset( EEG );
            if CheckBeforeSaving; pop_eegplot(EEG, 1, 0, 0); pause; end 
            EEG = pop_saveset(EEG, 'filename', filename.out ,'filepath', dirs.save);

        end 

    end 
    clear ALLEEG EEG CURRENTSET ALLCOM;
end 
