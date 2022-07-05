
EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it

cd('')
path=pwd;

files=dir('*.set');

for i=1:length(files)
% for i=1:7
    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath',path);
    ECG=EEG;
    ECG.data=EEG.data(64,:);
    save(string(strcat('',filename(1:end-4),'.mat')),'ECG')
end


%%
cd(')
path=pwd;

files=dir('*.set');

for i=1:length(files)
% for i=1:7
    filename=files(i).name;
    EEG = pop_loadset('filename',filename,'filepath',path);
    ECG=EEG;
    ECG.data=EEG.data(64,:);
    save(string(strcat('',filename(1:end-4),'.mat')),'ECG')
end
