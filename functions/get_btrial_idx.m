function [idx] = get_btrial_idx(subj)
    load(fullfile('/Volumes/K^2/curioEEG/data/preprocessed/phase2_long_ep/step3_clean/', ['auto_trial_rejection_' subj '.mat']));
    idx = find(btrialvec.jointprob); 
end 