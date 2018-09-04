clc, clear all;

load('posicionesallbd.mat');

%% Variables globales
num_coefs = 10;
num_test = length(unique(posicionesallbd.idtest));

coeficientes = cell(num_test,1);

counter = 1;
lim_inferior = 1.5; % desde 2 metros
lim_superior = 3.5; % hasta n metros

%%

cedulas = unique(posicionesallbd.cc);

for i=1:length(cedulas)
    
    cc = cedulas(i);
    sub_posicionesallbd = posicionesallbd(posicionesallbd.cc==cc,:);
    ids_test = unique(sub_posicionesallbd.idtest);
    
    for j=1:length(ids_test)
        idt = ids_test(j);
        paciente_posicionesallbd = sub_posicionesallbd(strcmp(sub_posicionesallbd.idtest,idt),:);
        
        signal_left = paciente_posicionesallbd(strcmp(paciente_posicionesallbd.JointType,'AnkleLeft'),[8,11]);
        signal_right = paciente_posicionesallbd(strcmp(paciente_posicionesallbd.JointType,'AnkleRight'),[8,11]);
        
        % Indexes signal in valid range
        index_left = indexes_signal_in_valid_range(signal_left.JointZ,lim_inferior,lim_superior);
        index_right = indexes_signal_in_valid_range(signal_right.JointZ,lim_inferior,lim_superior);
        
        signal_left = signal_left(index_left(1):index_left(2),:);
        signal_right = signal_right(index_right(1):index_right(2),:);
        
        % Time Conversion
        signal_left.TimeData = signal_left.TimeData/10000000;
        signal_right.TimeData = signal_right.TimeData/10000000;
        
        %signal_left.TimeData = datetime(signal_left.TimeData,'Format','mm:ss.SSS');
        %signal_right.TimeData = datetime(signal_right.TimeData,'Format','mm:ss.SSS');
        %
       
        coeficientes{counter,1} = cc;
        coeficientes{counter,2} = idt;
        coeficientes{counter,3} = generate_coeficientes(signal_left.TimeData, signal_left.JointZ,num_coefs);    
        coeficientes{counter,4} = generate_coeficientes(signal_right.TimeData, signal_right.JointZ,num_coefs);
        
        counter = counter + 1;
    end 
end

date_to_save = datestr(now,'dd_mmm_yyyy_HH_MM_SS');

%% save file icc
tablon = cell2table(coeficientes);
tablon.Properties.VariableNames{'coeficientes1'} = 'id';
tablon.Properties.VariableNames{'coeficientes2'} = 'idtest';
tablon = [tablon(:,1:2),...
    table(tablon.coeficientes3(:,1),'VariableNames',{'coeficientesleft1'}),...
    table(tablon.coeficientes3(:,2),'VariableNames',{'coeficientesleft2'}),...
    table(tablon.coeficientes3(:,3),'VariableNames',{'coeficientesleft3'}),...
    table(tablon.coeficientes3(:,4),'VariableNames',{'coeficientesleft4'}),...
    table(tablon.coeficientes3(:,5),'VariableNames',{'coeficientesleft5'}),...
    table(tablon.coeficientes3(:,6),'VariableNames',{'coeficientesleft6'}),...
    table(tablon.coeficientes3(:,7),'VariableNames',{'coeficientesleft7'}),...
    table(tablon.coeficientes3(:,8),'VariableNames',{'coeficientesleft8'}),...
    table(tablon.coeficientes3(:,9),'VariableNames',{'coeficientesleft9'}),...
    table(tablon.coeficientes3(:,10),'VariableNames',{'coeficientesleft10'}),...
    table(tablon.coeficientes3(:,11),'VariableNames',{'coeficientesleft11'}),...
    table(tablon.coeficientes4(:,1),'VariableNames',{'coeficientesright1'}),...
    table(tablon.coeficientes4(:,2),'VariableNames',{'coeficientesright2'}),...
    table(tablon.coeficientes4(:,3),'VariableNames',{'coeficientesright3'}),...
    table(tablon.coeficientes4(:,4),'VariableNames',{'coeficientesright4'}),...
    table(tablon.coeficientes4(:,5),'VariableNames',{'coeficientesright5'}),...
    table(tablon.coeficientes4(:,6),'VariableNames',{'coeficientesright6'}),...
    table(tablon.coeficientes4(:,7),'VariableNames',{'coeficientesright7'}),...
    table(tablon.coeficientes4(:,8),'VariableNames',{'coeficientesright8'}),...
    table(tablon.coeficientes4(:,9),'VariableNames',{'coeficientesright9'}),...
    table(tablon.coeficientes4(:,10),'VariableNames',{'coeficientesright10'}),...
    table(tablon.coeficientes4(:,11),'VariableNames',{'coeficientesright11'})];

disp('done');