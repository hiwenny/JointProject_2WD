% z3291315, Jordan Stewart, MTRN3100, s2, 2012
% file that graphs and processes data
function buffer = main(r, buffer)
% optional: read and ignore pending messages, for flushing old messages.
    for j=1:r.nr,                    % for each read message process it
      buffer = ProcessMessage( r.Data(:,j),r.timesCx(:,j), buffer) ;  % do something with each read message
    end;
return;
%....................................................

% processes the message...
function buffer = ProcessMessage( msg,t_cx, buffer)
% t_cx(1) is the timestamp when the message arrived to the PC.
% t_cx(2) is the message counter.
% msg[] contains the message [[SID][DID][L][DATA[]] (it excludes HEADER and CS)

SID = msg(1) ;
DID = msg(2) ;
L = msg(3) ;
if (L>20), return ;  end ; %suspicious message

time = double(t_cx(1))/10000 ;  % timestamp , in expressed seconds
data = double(msg(4:4+L-1));
buffer = Buffer1(data, time, buffer);
%fprintf('t=%.3f,cx=[%d],Sender=[%x],Dest=[%x],L=[%d],Data={',time, t_cx(2), SID, DID, L);

%--------------- PRINTING-------------
fprintf('%d,',data); fprintf('}\n');
%fprintf('%02x,',time); fprintf('}\n');
return ;
%....................................................

function buffer = Buffer1( data, time, buffer)
% initialize some Circular Buffer, for recording certain variables of
% interesst for me (speed and steering values).

buffer = Bufferreset(buffer);

%saves data to buffer
buffer.Data(1,buffer.index)= data(3)+data(4)*256; 
buffer.Data(2,buffer.index)= data(5)+data(6)*256;
buffer.Data(3,buffer.index)= data(7)+data(8)*256;
%.......................

%saves time to buffer
buffer.time(1,buffer.index)= time;
buffer.time(2,buffer.index)= time;
buffer.time(3,buffer.index)= time;

buffer.c=buffer.c+1;
if(buffer.c>10), %update 1 in 10
    buffer.c=0;    
    % here I update graphics.
    set( buffer.hp1 , 'ydata', buffer.Data(1,:));
    set( buffer.hp2 , 'ydata', buffer.Data(2,:));
    set( buffer.hp3 , 'ydata', buffer.Data(3,:));
    %'xdata', buffer.time(:)
end;
buffer.index=buffer.index+1;

%......................
return ;

function buffer = Bufferreset(buffer)
    if buffer.index>=buffer.L,
        buffer.index=1; %initial value
        for i=1:199, %increments up by 1
            buffer.Data(:,buffer.index)= buffer.Data(:,buffer.index+1);
            buffer.index=buffer.index+1;
        end;
        buffer.index=199;
    end;
return;
