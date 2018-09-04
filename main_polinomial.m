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
