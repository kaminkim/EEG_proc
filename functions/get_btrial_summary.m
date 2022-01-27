dirs.pj = '/Volumes/HD/project_dir/';
flist = dir([ dirs.pj 'data/preprocessed/phase2_long_ep/step3_clean/']) ; 
btrial = []; rowcount = 1; 
for iFile = 1: length(flist)
    if ~isempty(strfind(flist(iFile).name, '.mat'))
        load(fullfile(flist(iFile).folder, flist(iFile).name))
        btrial(rowcount, 1) = sum(btrialvec.jointprob);
        btrial(rowcount, 2) = sum(btrialvec.rejsuperpose);
        rowcount = rowcount+1;       
    end    
end 