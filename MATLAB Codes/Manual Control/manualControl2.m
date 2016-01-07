function manualControl

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demonstrates how to get the currently pressed key in MATLAB.            %
%                                                                         %
% Acknowledgement to Jos van der Geest in the creation of this code:      %
% http://www.mathworks.com/matlabcentral/fileexchange/7465-getkey         %
%                                                                         %
% Sam Marden 2012                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

api = iniApiMTRN3100();

%Error Checking
if api.Ok < 1,
    fprintf('API not ok\n');
    return;
end

% Set up figure.
f = figure('keypressfcn','set(gcbf,''Userdata'',get(gcbf,''Currentkey''));',...
    'keyreleasefcn','set(gcbf,''Userdata'',[])');
pause(0.1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START EXAMPLE USAGE.
while 1
    
    % isKeyPressed - 1 if a key is pressed at that moment, 0 if not.
    % keyPressed - string representing the key pressed, empty string [] if
    % no key is pressed.
    [isKeyPressed keyPressed] = getCurrentKeyPress(f);
    
    % Check if a key is currently pressed.
    if isKeyPressed
        %%%%%%%%%%%%%-------------Need to add the implementation now------
        switch(keyPressed)
            
            % W
            case 'w'
                fprintf('Forwards\n');
                y = [3 1000 1000]; % was 3 25 25 50 50
                
            % A
            case 'a'
                fprintf('Left\n');
                y = [3 0 500];
                
            % S
            case 's'
                fprintf('Backwards\n');
                y = [3 -500 500];
                
            % D
            case 'd'
                fprintf('Right\n');
                y = [3 50 0];
            
            % ESC
            
            case '1'
                fprintf('led light on\n');
                y = [6 29];
                
            case '2'
                fprintf('led light off\n');
                y = [6 13];
                
            case 'escape'
                fprintf('End\n');
                close;
                break;
                
        end
        
        api.PushMTRN3100Msg(1, y, 170, 187);
        
    end

    pause(0.1);
    
end
% END EXAMPLE USAGE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

% Function to get key info.
function [isKeyPressed keyPressed] = getCurrentKeyPress(f)

    keyPressed = get(f, 'Userdata');
    isKeyPressed = ~isempty(keyPressed);
    
end