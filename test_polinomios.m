clc, clear all;
load('interpolar_left.mat')

[t,z] = fill_missing_gait_signal(pleft_wrist_z.TimeData, pleft_wrist_z.JointZ);

p_x = polyfit(t,z,10);

x1 = linspace(min(t),max(t));
y1 = polyval(p_x,x1);

figure; plot(t,z); hold on; plot(x1,y1);
legend('original','polinomio')