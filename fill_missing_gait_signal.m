function [new_t,new_z] = fill_missing_gait_signal(t,z)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
z(z==0)=NaN;
%y = interpft(z,N);
new_t = fillmissing(t,'linear');
new_z=fillmissing(z,'linear');

%figure; plot(t,z);hold on; plot(new_t,new_z); legend('z-original','interpolada');

end

