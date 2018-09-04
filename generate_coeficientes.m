function [ p_x ] = generate_coeficientes( time_signal, data_signal, num_coefs)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
[t,z] = fill_missing_gait_signal(time_signal, data_signal);

p_x = polyfit(t,z,num_coefs);
% para completar señales de marcha en arm_validation
%http://la.mathworks.com/help/signal/examples/reconstructing-missing-data.html
% y = fillgaps(gapSignal);

%test 
% http://la.mathworks.com/help/signal/examples/extracting-classification-features-from-physiological-signals.html

%% Para graficar
%x1 = linspace(min(t),max(t));
%y1 = polyval(p_x,t);

%figure; plot(t,z); hold on; plot(t,y1);
%legend('original','polinomio')

end

