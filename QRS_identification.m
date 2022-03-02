% EEGLAB history file generated on the 17-Jun-2020
% ------------------------------------------------
%% 1st Method - fMRI tool
clear all;
addpath 'C:\Users\JulioMedeiros\Desktop\Study1_EEG\eeglab14_1_2b'

eeglab

cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\')
% cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\problemas\GA')
path=pwd;

files=dir('*.set');
container=[];
for i=2:length(files)
    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath',path);
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 1000);
    EEG = eeg_checkset( EEG );
%     idx_start=find(strcmp({EEG.event.type},'99'));
    idx_start=find(strcmp({EEG.event.type},'keypad5'));
%     if (EEG.event(idx_start).latency-80) > 0
        time_start=(EEG.event(idx_start(1)).latency)/EEG.srate;
        EEG = pop_select( EEG,'notime',[0 time_start] );
        EEG = eeg_checkset( EEG );
%     else
%         container=[container, i];
%     end
    
    %narrower frequency band (4-45 Hz) was applied to the ECG signal, as to increase QRS complex detection accuracy
    ECG=EEG;
    ECG = pop_select( ECG,'channel',{'EKG'});
    ECG = pop_eegfiltnew(ECG, [],4,[],1,[],0);
    ECG = pop_eegfiltnew(ECG, [],45,[],0,[],0);

    EEG.data(64,:)=ECG.data(1,:);
    EEG=pop_fmrib_qrsdetect(EEG,64,'qrs','no');
    EEG = eeg_checkset( EEG );
    EEG.setname=strcat(filename(1:end-4),'_re',num2str(EEG.srate),'hz_QRS');
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath',strcat(path,'\1000QRS'));
    EEG = eeg_checkset( EEG );
end

%% 2nd method - R-peak detector based on the Pan & Tompkins algorithm

% cd('C:\\Users\\JulioMedeiros\\Desktop\\analysis\\importfiles\\triggers\\GA\\')
% 
addpath('C:\Users\JulioMedeiros\Desktop\funcoes\ECG Adriana\ALG_FINAL_WELCOME_ADRIANA')

cd('C:\Users\JulioMedeiros\Desktop\analysis\importfiles\triggers\problemas\GA')
path=pwd;

files=dir('*.set');

container=[];
for i=1:length(files)
    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath',path);
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 1000);
    EEG = eeg_checkset( EEG );
    idx_start=find(strcmp({EEG.event.type},'keypad5'));
%     if (EEG.event(idx_start).latency-80) > 0
        time_start=(EEG.event(idx_start(1)).latency)/EEG.srate;
        EEG = pop_select( EEG,'notime',[0 time_start] );
        EEG = eeg_checkset( EEG );
%     else
%         container=[container, i];
%     end
    ECG=EEG;
    ECG = pop_select( ECG,'channel',{'EKG'});
    ECG = pop_eegfiltnew(ECG, [],4,[],1,[],0);
    ECG = pop_eegfiltnew(ECG, [],45,[],0,[],0);
%     [detected,det_RS]=SignalNoiseDetectionControl(ECG,EEG.srate);
    ECG_signal=double(ECG.data);
    [det_RS]=QRSdetection(ECG_signal,ECG.srate,0);
    for idx=1:length(det_RS)
        EEG = pop_editeventvals(EEG,'insert',{1 [] [] []},'changefield',{1 'type' 'qrs'},'changefield',{1 'latency' EEG.times((det_RS(idx)))/1000});
        EEG = eeg_checkset( EEG );
    end
    
    EEG.setname=strcat(filename(1:end-4),'_re',num2str(EEG.srate),'hz_QRS_pantompkins');
    EEG = pop_saveset( EEG, 'filename',strcat(EEG.setname,'.set'),'filepath',strcat(path,'\1000QRS_Pan'));

end
% 
% %% Plotting
% addpath('C:\Users\JulioMedeiros\Desktop')
% 
% ECG=double(EEG.data(64,:));
% plotscroll(ECG_signal,det_RS,ECG.srate,20)