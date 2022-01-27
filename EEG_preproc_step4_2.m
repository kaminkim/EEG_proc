%% EEG preprocessing  step3: clean data 
% 3_2 Run SASICA and remove eye blink-driven artifacts
% KK April 2019
 
%% add path to eeglab 
%%
dirs.pj = '/Volumes/HD/project_dir/';

dirs.in = [dirs.pj 'data/preprocessed/phase2_long_ep/step4_ica/'];
dirs.out = [dirs.pj 'data/preprocessed/phase2_long_ep/step4_ica/'];

% set up subjects and processing steps
subjects = [1:10]; 

%% load and epoch data 
% load eeglab 
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for iSub = 1 %: length(subjects)     
    if subjects(iSub) < 10
        subnum = ['s0', num2str(subjects(iSub))];
    else
        subnum = ['s' num2str(subjects(iSub))];
    end   
    filename.in = ['phase2long_' subnum '_ep_interp_ica.set'];
    
    EEG = pop_loadset( 'filename', filename.in , 'filepath', dirs.in);

    % SASICA
    cfg = struct;
    cfg.trialfoc.enable = true; 
    
    %% CHECK EOG CHAN NAMES 
    if ismember(subnum, {'15', '17', '18', '19', '20'})
        cfg.EOGcorr.Veogchannames = {'RHEOG', 'UVEOG'}; 
        cfg.EOGcorr.Heogchannames = {'LHEOG', 'VEOG'};              
    else 
        cfg.EOGcorr.Veogchannames = {'VEOG', 'UVEOG'}; %[69 70];% vertical channel(s)
        cfg.EOGcorr.Heogchannames = {'LHEOG', 'RHEOG'}; %[67 68];% horizontal channel(s)              
    end 
    cfg.EOGcorr.corthreshV = 0.4;
    cfg.EOGcorr.corthreshH = 0.4;
    cfg.chancorr.corthresh = 0.4;               
    cfg.chancorr.enable = false;
    cfg.chancorr.channames = {'LHEOG', 'RHEOG', 'VEOG', 'UVEOG'};
    cfg.ADJUST.enable = true;
    cfg.FASTER.enable = false;
    cfg.FASTER.blinkchanname = {'LHEOG', 'RHEOG', 'VEOG', 'UVEOG'};
    cfg.MARA.enable = false;
    cfg.opts.noplot = 0;
    EEG = eeg_SASICA(EEG,cfg);     
    
    % plot component timeseriese and compare with blinks
    eeglab redraw
    pause; 
    close all; 
end 