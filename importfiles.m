clear all; clc; close all

% cd('D:\Data_study1\fmri free')
cd('D:\Data_study1\problemas')

subject=dir('*');
subject=subject(3:end,:);


for s=1:length(subject)
    tic
    
    subject_file=subject(s).name;
%     cd(strcat('D:\Data_study1\fmri free\',subject_file,'\EEG'))
cd(strcat('D:\Data_study1\problemas\',subject_file,'\EEG'))
    run_files=dir('*inside Data.cnt');
    

    for m=1:length(run_files)
        name_file=run_files(m).name;
        run=regexp(name_file, '\d+', 'match');
%         EEG = pop_loadcnt(strcat('D:\Data_study1\fmri free\',subject_file,'\EEG\',name_file), 'dataformat', 'auto', 'keystroke', 'on', 'memmapfile', '');
        EEG = pop_loadcnt(strcat('D:\Data_study1\problemas\',subject_file,'\EEG\',name_file), 'dataformat', 'auto', 'keystroke', 'on', 'memmapfile', '');
        name=strcat(subject_file,'_run',run{1});
        EEG.setname=name;
        EEG = eeg_checkset( EEG );
        EEG = pop_saveset( EEG, 'filename',name,'filepath','C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\problemas\\');
        EEG = eeg_checkset( EEG );
    end
end