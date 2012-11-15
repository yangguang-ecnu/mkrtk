function kpf3d(hf,event)
%KPF3D Key Press Function for 3D cloud viewing
%
% KPF3D calls the slider callback function if the slider is visible

validKeys = {'rightarrow','leftarrow'};


% Exit if the key pressed has not been implemented:
if ~any( strcmp(validKeys,event.Key) )
    return
end


% Scroll amount & new position
switch event.Key
    % Scroll the slider right or left:
    case 'rightarrow'
        s = +1;
    case 'leftarrow'
        s = -1;
end

% Now use swf3d to do the hard work:
event.VerticalScrollCount = s;
swf3d(hf,event);