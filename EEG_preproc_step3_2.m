%  EEG preprocessing  step3_2: screen trials & channels using
%  fieldtrip 

clear all;
restoredefaultpath;
addpath /Users/kaminkim/Documents/toolboxes/fieldtrip;
ft_defaults;

dirs.pj = '/Volumes/HD/project_dir/';
dirs.in_eeg = [dirs.pj 'data/preprocessed/phase2_long_ep/step1_cont/'];
dirs.in_autobtrials = [dirs.pj 'data/preprocessed/phase2_long_ep/step3_clean/'];
dirs.out_ep = [dirs.pj 'data/preprocessed/phase2_long_ep/step2_ep/'];
dirs.out_clean = [dirs.pj 'data/preprocessed/phase2_long_ep/step3_clean/'];

% set up subjects and processing steps
subj = 's01'; 

%%
% epoch in fieldtrip - needed to view trial stats; save it in _ep directory
% for quick loading later. 
rdata = ['phase2long_' subj '_ds_ref_filt.set']; 
wdata = [rdata(1: strfind(rdata, '.set')-1) '.mat'];
cfg = []; 
cfg.dataset             = [dirs.in_eeg rdata];
cfg.trialfun            = 'ft_trialfun_general'; % default
cfg.trialdef.eventtype  = 'trigger'; 
cfg.trialdef.eventvalue = [21:26]; 
cfg.trialdef.prestim    = 1; % a postive num in sec
cfg.trialdef.poststim   = 16.5; 
cfg                     = ft_definetrial(cfg);
data                    = ft_preprocessing(cfg); 
save([dirs.out_clean wdata], 'data'); 

% review channel & trial summary -- also view trials that were captured via
bchanidx = find(ismember(data.label, get_bchan(subj))); 
load (fullfile(dirs.in_autobtrials, ['auto_trial_rejection_' subj '.mat'])); 
auto_rejtrials = find(btrialvec.jointprob); 
txt{1} = sprintf(['Logged bad channels: ' num2str(bchanidx')]);  
txt{2} = sprintf(['Auto-rejected trials: ' num2str(auto_rejtrials)]); 
msgbox(txt);

% nan bad channels & bad trials 
cfg = []; 
cfg.method              = 'summary'; 
cfg.channel             = setdiff([1:64], bchanidx); 
cfg.keepchannel         = 'nan'; % uses wiehted average as default
cfg.keeptrial           = 'nan'; 
cfg.alim                = 100; 
data                 = ft_rejectvisual(cfg, data);
ft_rejtrials = find(cell2mat(cellfun(@(x) sum(sum(~isnan(x))) == 0, data.trial, 'UniformOutput', false))); 
tmp_trials = setdiff([1: length(data.trial)], ft_rejtrials); 
ft_bchans = [bchanidx, intersect(cfg.channel, find(isnan(nanmean(data.trial{1}, 2))))]; 

save([dirs.out_clean subj '_data_cleaning.mat'], 'auto_rejtrials', 'ft_rejtrials', 'ft_bchans');
