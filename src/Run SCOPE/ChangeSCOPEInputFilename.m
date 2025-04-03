function ChangeSCOPEInputFilename(files)

    % change input file in SCOPE simulation 
    path_set_pars_file = fullfile(files.SCOPE_dir_loc,'set_parameter_filenames.csv');
    
    C = readcell(path_set_pars_file);
    
    C{3} = files.SCOPE_new_input;
    
    writecell(C,path_set_pars_file,'Delimiter',',')

end