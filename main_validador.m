clc, clear all;
%% Variables globales
name_folder = 'S1_Data';
num_subjects=21;
type_of_test = 'CWS'; %comfortable walking speed (CWS) and maximum walking speed (MWS). 
num_test = 3; % 3 first test were at CWS, 3 last test were at MWS

counter = 1;
lim_inferior = 2; % desde 2 metros
lim_superior = 8; % hasta n metros
distancia_str = strcat(mat2str(lim_inferior),'_',mat2str(lim_superior),'metros');

completar_con = 1;% 0 para reemplazar por 0 y 1 para reemplazar por NaN e interpolar

if completar_con == 0
    aux_name_file = strcat('nan_values_',type_of_test);
elseif completar_con == 1
    aux_name_file = strcat('interpolado',type_of_test);
end

all_name_files = cell(num_subjects*num_test,1);
result_icc = cell(num_subjects*num_test,1);
arm_variables_kinect = cell(num_subjects*num_test,1);
arm_variables_optotrack = cell(num_subjects*num_test,1);

%% Extracción de pruebas
for index = 1:num_subjects
    for index2 = 1:num_test
        name_file = strcat('pp', mat2str(index),'_trial',mat2str(index2)');
        full_name_file = strcat(pwd,'\',name_folder,'\',name_file,'.xls');
        full_data = importfile(full_name_file,completar_con); 
        full_data = full_data(2:end,:);
        
        left_kinect = full_data.KinectxWristLeft';
        right_kinect = full_data.KinectxWristRight';
        hip_center_kinect = full_data.KinectxSpineBase';
        
        %% In the articule, they used spline algorithm
            % in the subject 9, test 1; and subject 21, test 2, spline algorithm doesnt generate
            % good results
            
        if hasInfNaN(left_kinect)
            left_kinect = pchip(1:length(left_kinect),left_kinect, 1:length(left_kinect));
        end
        if hasInfNaN(right_kinect)
            right_kinect = pchip(1:length(right_kinect), right_kinect, 1:length(right_kinect));
        end
        if hasInfNaN(hip_center_kinect)
            hip_center_kinect = pchip(1:length(hip_center_kinect), hip_center_kinect, 1:length(hip_center_kinect));
        end
       
        left_optotrack = full_data.OptotrakxWristLeft';
        right_optotrack=full_data.OptotrakxWristRight';
        hip_center_optotrack=full_data.OptotrakxSpineBase';
        
        if hasInfNaN(left_optotrack)
            left_optotrack = pchip(1:length(left_optotrack),left_optotrack, 1:length(left_optotrack));
        end
        if hasInfNaN(right_optotrack)
            right_optotrack = pchip(1:length(right_optotrack), right_optotrack, 1:length(right_optotrack));
        end
        if hasInfNaN(hip_center_optotrack)
            hip_center_optotrack = pchip(1:length(hip_center_optotrack), hip_center_optotrack, 1:length(hip_center_optotrack));
        end
        
        %% ICC(C,1) con 95% CI -> 0.05
        [r_arm_left, LB_arm_left, UB_arm_left, F_arm_left, df1_arm_left, df2_arm_left,...
            p_arm_left] = ICC([left_kinect',right_kinect'],'C-1',0.05,0.5);
        
        [r_arm_right, LB_arm_right, UB_arm_right, F_arm_right, df1_arm_right, df2_arm_right, ...
            p_arm_right] = ICC([right_kinect',right_optotrack'],'C-1',0.05,0.5);
        
        [r_hip, LB_hip, UB_hip, F_hip, df1_hip, df2_hip, ...
            p_hip] = ICC([hip_center_kinect',hip_center_optotrack'],'C-1',0.05,0.5);
        
        result_arm_left     = [r_arm_left, LB_arm_left, UB_arm_left];
        result_arm_right    = [r_arm_right, LB_arm_right,UB_arm_right ];
        result_hip          = [r_hip, LB_hip, UB_hip];
        
    
        all_name_files{counter,1} = name_file;
        result_icc{counter,1} = [result_arm_left,result_arm_right,result_hip];
        
        
        %% arm swing analysis
        arm_variables_kinect{counter,1} = generate_arm_variables(left_kinect, right_kinect, hip_center_kinect, lim_inferior, lim_superior,'Kinect',name_file,completar_con);
        arm_variables_optotrack{counter,1} = generate_arm_variables(left_optotrack, right_optotrack,hip_center_optotrack, lim_inferior, lim_superior,'Optotrack',name_file,completar_con);
         
        counter = counter + 1;
    end
end

date_to_save = datestr(now,'dd_mmm_yyyy_HH_MM_SS');

%% save file icc
tablon = [all_name_files, result_icc];
tablon = cell2table(tablon);

% rename cols table
tablon.Properties.VariableNames{'tablon1'} = 'id';
tablon = [tablon.id(:,1:1),...
    table(tablon.tablon2(:,1),'VariableNames',{'r_arm_left'}),...
    table(tablon.tablon2(:,2),'VariableNames',{'LB_arm_left'}),...
    table(tablon.tablon2(:,3),'VariableNames',{'UB_arm_left'}),...
    table(tablon.tablon2(:,4),'VariableNames',{'r_arm_right'}),...
    table(tablon.tablon2(:,5),'VariableNames',{'LB_arm_right'}),...
    table(tablon.tablon2(:,6),'VariableNames',{'UB_arm_right'}),...
    table(tablon.tablon2(:,7),'VariableNames',{'r_hip'}),...
    table(tablon.tablon2(:,8),'VariableNames',{'LB_hip'}),...
    table(tablon.tablon2(:,9),'VariableNames',{'UB_hip'})];


%% save file variables Kinect
tablon_kinect_arm = [all_name_files, arm_variables_kinect];
tablon_kinect_arm = cell2table(tablon_kinect_arm);

% rename cols table
tablon_kinect_arm.Properties.VariableNames{'tablon_kinect_arm1'} = 'id';
tablon_kinect_arm = [tablon_kinect_arm.id(:,1:1),...
    table(tablon_kinect_arm.tablon_kinect_arm2(:,1),'VariableNames',{'Prom_mag_left'}),...
    table(tablon_kinect_arm.tablon_kinect_arm2(:,2),'VariableNames',{'Prom_time_left'}),...
    table(tablon_kinect_arm.tablon_kinect_arm2(:,3),'VariableNames',{'Prom_speed_left'}),...
    table(tablon_kinect_arm.tablon_kinect_arm2(:,4),'VariableNames',{'Prom_mag_right'}),...
    table(tablon_kinect_arm.tablon_kinect_arm2(:,5),'VariableNames',{'Prom_time_right'}),...
    table(tablon_kinect_arm.tablon_kinect_arm2(:,6),'VariableNames',{'Prom_speed_right'})];

%% save file variables Optotrack
tablon_optotrack_arm = [all_name_files, arm_variables_optotrack];
tablon_optotrack_arm = cell2table(tablon_optotrack_arm);

% rename cols table
tablon_optotrack_arm.Properties.VariableNames{'tablon_optotrack_arm1'} = 'id';
tablon_optotrack_arm = [tablon_optotrack_arm.id(:,1:1),...
    table(tablon_optotrack_arm.tablon_optotrack_arm2(:,1),'VariableNames',{'Prom_mag_left'}),...
    table(tablon_optotrack_arm.tablon_optotrack_arm2(:,2),'VariableNames',{'Prom_time_left'}),...
    table(tablon_optotrack_arm.tablon_optotrack_arm2(:,3),'VariableNames',{'Prom_speed_left'}),...
    table(tablon_optotrack_arm.tablon_optotrack_arm2(:,4),'VariableNames',{'Prom_mag_right'}),...
    table(tablon_optotrack_arm.tablon_optotrack_arm2(:,5),'VariableNames',{'Prom_time_right'}),...
    table(tablon_optotrack_arm.tablon_optotrack_arm2(:,6),'VariableNames',{'Prom_speed_right'})];

writetable(tablon,strcat('icc_left_right_hip_anteriorposterior_',distancia_str,aux_name_file,'_',date_to_save,'.xlsx'));
writetable(tablon_kinect_arm,strcat('arm_variables_kinect_',distancia_str,aux_name_file,'_',date_to_save,'.xlsx'));
writetable(tablon_optotrack_arm,strcat('arm_variables_optotrack_',distancia_str,aux_name_file,'_',date_to_save,'.xlsx'));