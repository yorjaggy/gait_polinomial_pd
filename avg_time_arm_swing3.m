function [aux_ciclos, aux_time ]= avg_time_arm_swing3(times)
%avg_time_arm_swing receives two cell arrays with the peak times 
 %   times_down, times_up
 %   the first parameter is the times of the down peaks
 %   the second parameter is the times of the up peaks

aux_time = 0;
if(isempty(times)); aux_time = 0; aux_ciclos = 0; return; end;

aux_length = length(times);
aux_ciclos = 0;

for w=1:3:aux_length
    
    if(w+2<=aux_length)
        aux_ciclos = aux_ciclos + 1;
        t2 = times(w+2);
        t1 = times(w);
        
        t2=seconds(t2);
        t1=seconds(t1);
        
        time_diff = t2-t1;
        
        aux_time = aux_time + seconds(time_diff);
    end
end
aux_time = aux_time/(aux_ciclos);
end