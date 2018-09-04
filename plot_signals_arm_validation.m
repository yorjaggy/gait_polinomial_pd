%% Grafico 1
figure1 = figure;
axes1 = axes('Parent',figure1);
set(figure1,'Position',[0, 0, 1024, 768]);
set(figure1,'Visible','off');%Muestra o no la imagen.
hold(axes1,'all');

    plot(time_vec_left, new_left,'-r');hold on;
    plot(time_vec_right, new_right,'-g');hold on;
   
    plot(time_vec_left,left,'-r');hold on;
    plot(time_vec_right,right,'-g');hold on;
    
    plot(time_vec_left, den_left_wrist_z,'--r');hold on;
    plot(time_vec_right, den_right_wrist_z,'--g');hold on;
    %plot(phip_center_z.TimeData,phip_center_z.JointZ);

legend('Left - Only Swing','Right - Only Swing',...
    strcat('Left - ',name_device),strcat('Right - ',name_device),...
    strcat('Left Denoised - ',name_device),strcat('Right Denoised - ',name_device));  
xlabel('# Elements','FontSize',16);
ylabel('Distance (m)','FontSize',16);
ylim([-0.55 11]);
title(strcat('Senal Acortada',' - ',name_device),'FontSize',16);

%% Graficos izquierda
figure2 = figure;
axes1 = axes('Parent',figure2);
set(figure2,'Position',[0, 0, 1024, 768]);
set(figure2,'Visible','off');%Muestra o no la imagen.
hold(axes1,'all');
    plot(time_vec_left,new_left); hold on;
    plot(time_vec_left,den_left_wrist_z);hold on;

    plot(time_vec_left(locs_left_paciente),pks_left_paciente,'rv','MarkerSize',9);hold on;    
    plot(time_vec_left(locs_left_paciente2),-pks_left_paciente2,'rs','MarkerSize',9);hold on;

legend('Left','Left Denoised','Up Peaks','Down Peaks');
xlabel('# Elements','FontSize',16);
ylabel('Distance (m)','FontSize',16);
posx=time_vec_left(floor(length(new_left)/2));
text(posx, 0.40, strcat('MagnitudP : ',mat2str(magnitud_left)),'FontSize',14);
text(posx, 0.35, strcat('Media: ',mat2str(media_left)),'FontSize',14);
text(posx, 0.30, strcat('Dev.Std: ',mat2str(std_left)),'FontSize',14);
%axis([1 length(pleft_wrist_z.newZ) -0.55 0.55]);
% if length(pleft_wrist_z.newZ)>1
%        axis([1 length(pleft_wrist_z.newZ) -0.55 0.55]);
%    end
ylim([-0.55 0.55]);
title(strcat('Peaks Analisys - Left',' - ',name_device),'FontSize',16);
    
%% Graficos derecha

figure3 = figure;
axes1 = axes('Parent',figure3);
set(figure3,'Position',[0, 0, 1024, 768]);
set(figure3,'Visible','off');%Muestra o no la imagen.
hold(axes1,'all');
    plot(time_vec_right,new_right); hold on;
    plot(time_vec_right,den_right_wrist_z); hold on;

    plot(time_vec_right(locs_right_paciente),pks_right_paciente,'rv','MarkerSize',9);hold on;
    plot(time_vec_right(locs_right_paciente2),-pks_right_paciente2,'rs','MarkerSize',9);hold on;

legend('Right','Right Denoised','Up Peaks','Down Peaks')
xlabel('# Elements','FontSize',16);
ylabel('Distance (m)','FontSize',16);
posx=time_vec_right(floor(length(new_right)/2));
text(posx, 0.40, strcat('MagnitudP : ',mat2str(magnitud_right)),'FontSize',14);
text(posx, 0.35, strcat('Media: ',mat2str(media_right)),'FontSize',14);
text(posx, 0.30, strcat('Dev.Std: ',mat2str(std_right)),'FontSize',14);
%axis([1 length(pright_wrist_z.newZ) -0.55 0.55])
%  if length(pright_wrist_z.newZ)>1
%        axis([1 length(pright_wrist_z.newZ) -0.55 0.55])
%    end
ylim([-0.55 0.55]);
title(strcat('Peaks Analisys - Right',' - ',name_device),'FontSize',16);
 

%% Guardar graficos
if completar_con == 0
    aux_process = 'nan_values';
elseif completar_con == 1
    aux_process = 'interpolado';
end

where = strcat('plots_txt_arm_validation_',distancia_str,aux_process,'-',date);
if ~exist(where,'dir'); mkdir(where); end
saveas(figure1,strcat(where,'/',name_file,'-RawData-',name_device,'.png'));  % saving the figure
saveas(figure2,strcat(where,'/',name_file,'-LeftPeaks-',name_device,'.png'));  % saving the figure
saveas(figure3,strcat(where,'/',name_file,'-RightPeaks-',name_device,'.png'));  % saving the figure

%savefig(figure1,strcat(where,'/',label_title,'-RawData','.fig'))
%savefig(figure2,strcat(where,'/',label_title,'-LeftPeaks','.fig'))
%savefig(figure2,strcat(where,'/',label_title,'-RightPeaks','.fig'))
%disp(strcat('test plotted and saved: ',label_title));
close all;