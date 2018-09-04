function [ret] = indexes_signal_in_valid_range(signal,minimo,mayor)
%RANGE_SIGNAL_IN_VALID_RANGE returns the indexes where start the signal (value)
%   closer to 3.5,

signal(signal>mayor)=0;
signal(signal<minimo)=0;

%%added

signal_clone = signal;
signal_clone(signal_clone~=0) = 1; 
dx = diff([0;signal_clone;0]);
start_pos = find(dx == 1);
end_pos = find(dx == -1)-1;
vector = [start_pos;end_pos];
vector = reshape(vector,[],2);

[nrow,ncols] = size(vector);

longitudes = zeros(1,nrow);

%verificar longitud
for i=1:nrow
    val_a = vector(i,1); val_b = vector(i,2);
    longitudes(i) = abs(val_a - val_b);    
end

valor_maxima_longitud = max(longitudes);
bool_longitudes = (longitudes == valor_maxima_longitud);

% if(~isempty(vector))
    ret = vector(bool_longitudes,:);
% else
%     ret = 0;
end