function [outputArg1] = generate_arm_variables(left, right, hipc_spine, lim_inferior, lim_superior,name_device,name_file,completar_con)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% Ajustar en rango valido desde lim_inferior hasta lim_superior
disp(name_file);
distancia_str = strcat(mat2str(lim_inferior),'_',mat2str(lim_superior),'metros');

index_left = indexes_signal_in_valid_range(left',lim_inferior,lim_superior);
index_right = indexes_signal_in_valid_range(right',lim_inferior,lim_superior);

left = left(index_left(1):index_left(2));
hip_left = hipc_spine(index_left(1):index_left(2));

right = right(index_right(1):index_right(2));
hip_right = hipc_spine(index_right(1):index_right(2));

new_left = left - hip_left;
new_right = right - hip_right;

%% ------ sgolayfilt------
order = 3;
framelen = 15;

den_left_wrist_z  = sgolayfilt(new_left,order,framelen);
den_right_wrist_z = sgolayfilt(new_right,order,framelen);

%% ------ peak detection ------
MinPeakDist = 15;
%Picos superiores
[pks_left_paciente,locs_left_paciente]=findpeaks(new_left, 'MinPeakDistance',MinPeakDist,'MinPeakProminence',0.01);
[pks_right_paciente,locs_right_paciente]=findpeaks(new_right,'MinPeakDistance',MinPeakDist,'MinPeakProminence',0.01);

%Picos inferiores
[pks_left_paciente2,locs_left_paciente2]=findpeaks(-new_left,'MinPeakDistance',MinPeakDist,'MinPeakProminence',0.01);
[pks_right_paciente2,locs_right_paciente2]=findpeaks(-new_right,'MinPeakDistance',MinPeakDist,'MinPeakProminence',0.01);

%% Validacion de valores minimos y maximos segun el umbral

validacion_media_left_superior = pks_left_paciente > mean(new_left);
validacion_media_right_superior = pks_right_paciente > mean(new_right);

validacion_media_left_inferior = (-1*pks_left_paciente2) < mean(new_left);
validacion_media_right_inferior = (-1*pks_right_paciente2) < mean(new_right);

% picos superiores 
pks_left_paciente = pks_left_paciente(validacion_media_left_superior);
locs_left_paciente = locs_left_paciente(validacion_media_left_superior);

pks_right_paciente = pks_right_paciente(validacion_media_right_superior);
locs_right_paciente = locs_right_paciente(validacion_media_right_superior);

% picos inferiores
pks_left_paciente2 = pks_left_paciente2(validacion_media_left_inferior);
locs_left_paciente2 = locs_left_paciente2(validacion_media_left_inferior);

pks_right_paciente2 = pks_right_paciente2(validacion_media_right_inferior);
locs_right_paciente2 = locs_right_paciente2(validacion_media_right_inferior);

%% Analisis de velocidades
%Velocidad promedio izquierda
frecuencia_muestreo= 30; % 30 Hz
% tiempo
time_vec_left = 1:length(left);
time_vec_left = time_vec_left/frecuencia_muestreo;

time_vec_right = 1:length(right);
time_vec_right = time_vec_right/frecuencia_muestreo;

if (isempty(locs_left_paciente2) || isempty(locs_left_paciente))
    avg_time_left=0;
else
    first_left_down = locs_left_paciente2(1);
    last_left_up = locs_left_paciente(end);

    % Cambio de coma (,) por punto y coma (;)
    all_peaks_left = [locs_left_paciente,locs_left_paciente2];
    all_peaks_left = sort(all_peaks_left);

    %all_peaks_left = all_peaks_left(all_peaks_left>=first_left_down);
    %all_peaks_left = all_peaks_left(all_peaks_left<=last_left_up);

    time_peaks_left = time_vec_left(all_peaks_left);

    [nciclos_left,avg_time_left] = avg_time_arm_swing3(time_peaks_left);
end
%Velocidad promedio derecha
if (isempty(locs_right_paciente2) || isempty(locs_right_paciente))
    avg_time_right=0;
else
    first_right_down = locs_right_paciente2(1);
    last_right_up = locs_right_paciente(end);

    all_peaks_right = [locs_right_paciente2,locs_right_paciente];
    all_peaks_right = sort(all_peaks_right);

    %all_peaks_right = all_peaks_right(all_peaks_right>=first_right_down);
    %all_peaks_right = all_peaks_right(all_peaks_right<=last_right_up);

    time_peaks_rigth = time_vec_right(all_peaks_right);

    [nciclos_right,avg_time_right] = avg_time_arm_swing3(time_peaks_rigth);
end
%% Promedio de picos

peaks_left_up = pks_left_paciente;
peaks_right_up = pks_right_paciente;

peaks_left_down = -pks_left_paciente2;
peaks_right_down = -pks_right_paciente2;

%Promedio left
prom_up_left = mean(peaks_left_up);
prom_down_left = mean(peaks_left_down);

%Promedio right
prom_up_right = mean(peaks_right_up);
prom_down_right = mean(peaks_right_down);

%% Results

%left:
magnitud_left = prom_up_left - prom_down_left;
media_left = mean(new_left);
std_left = std(new_left);
velocity_left = magnitud_left/avg_time_left;

%right:
magnitud_right = prom_up_right - prom_down_right;
media_right = mean(new_right);
std_right = std(new_right);
velocity_right = magnitud_right/avg_time_right;

left_variables = [magnitud_left avg_time_left velocity_left];
right_variables = [magnitud_right avg_time_right velocity_right];

%% plot signals script
plot_signals_arm_validation;

outputArg1 = [left_variables, right_variables];
end

