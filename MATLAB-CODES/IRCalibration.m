function main()
global MyStruct;

MyStruct.API =  iniApiMTRN3100();          % Api initialization
if MyStruct.API.Ok<1, return ; end;

% initializing buffer
Buffer.L=200;                   % buffer length
Buffer.Data=zeros(3,Buffer.L);  % making 2xL matrix of zeros
Buffer.index=0;                 % buffer index?? 
cx=0;

% create 3 plots, to be updated dynamically.
figure(1) ;clf ; 
hold on ;
DataPlot.hp1 = plot(Buffer.Data(1,:),'b') ;

while 1,                             % run loop indefinitely    
         r  =MyStruct.API.GetMTRN3100Msg(1,10) ;    % read pending messages
        for j=1:r.nr,
         % data processing
            data = double(r.Data(4)) + double(r.Data(5)*256);     % LSB was read first!!!!
            
            % convert readings to voltage. 1024 = 5volts so [datav]=[data]*5/1024
            x2 = data*5/1024;
            
            if x2<0.4
                len1 = 80;
                len3 = 81;
                x1 = 1;
                x3 = inf;
                % to make dist = 80;
            elseif x2<0.423
                x1 = 0.423;
                x3 = 0.4;
                len1 = 70;
                len3 = 80;
            elseif x2<0.5
                x1 = 0.5;
                x3 = 0.432;
                len1 = 60;
                len3 = 70;
            elseif x2<0.5875
                x1 = 0.5875;
                x3 = 0.5;
                len1 = 50;
                len3 = 60;
            elseif x2<0.725
                x1 = 0.725;
                x3 = 0.5875;
                len1 = 40;
                len3 = 50;
            elseif x2<0.95
                x1 = 0.95;
                x3 = 0.725;
                len1 = 30;
                len3 = 40;
            elseif x2<1.0625;
                x1 = 1.0625;
                x3 = 0.95;
                len1 = 25;
                len3 = 30;
            elseif x2<1.3
                x1 = 1.3;
                x3 = 1.0625;
                len1 = 20;
                len3 = 25;
            elseif x2<1.75
                x1 = 1.75;
                x3 = 1.3;
                len1 = 14.72;
                len3 = 20;
            elseif x2<2.25
                x1 = 2.25;
                x3 = 1.75;
                len1 = 10;
                len3 = 20;
            else 
                % to make dist = 10
                len1 = 10;
                len3 = 11;
                x1 = 1;
                x3 = inf;
            end;
     
            % linearization eqn
            dist = len1 + (x2-x1)/(x3-x1)*(len3-len1)
            % dist = len2

            
            % some buffering .......
            Buffer.index=Buffer.index+1;
            if Buffer.index>Buffer.L,
            %    Buffer.Data(:,:)=0;        % refreshes the buffer matrix
                Buffer.index=1;             % returning the index to 1
            end;
    
            Buffer.Data(1,Buffer.index)=dist;
            %.......................

            % plotting
            cx=cx+1;            
            if (cx>10),     
                cx=0;           % every 10 data, then refreshes
                set( DataPlot.hp1 , 'ydata', Buffer.Data(1,:));
            end;
        xlabel('time');
        ylabel('distance');
        end;
    pause(0.01) ;
end;
return;