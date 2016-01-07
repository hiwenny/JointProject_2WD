
% Example showing how to read incomming messages from robot or other node.
% Jose Guivant - July/2012 - MTRN3100

function main()

AAA =  iniApiMTRN3100();
if AAA.Ok<1, return ; end;          % if Not OK, ends this program..


% optional: read and ignore pending messages, for flushing old messages.
% r  =AAA.GetMTRN3100Msg(1,10) ; 

for i=1:1000,                        % run loop during some number of iterations.
    r  =AAA.GetMTRN3100Msg(1,10) ;   % read pending messages
    for j=1:r.nr,                    % for each read message we process it..
      ProcessMessage( r.Data(:,j),r.timesCx(:,j)) ;  % do something with each read message
    end;
    pause(0.2) ;% wait some time (no need to be reading in a crazy way..)
    % in other cases you may wait more o less, it depends on your other
    % tasks to be done in the loop.
end;

% program ends
fprintf('Program ENDS..\n');

return;

%....................................................


% in this function we can process the message...
function ProcessMessage( msg,t_cx)

% t_cx(1) is the timestamp when the message arrived to the PC.
% t_cx(2) is the message counter.
% msg[] contains the message [[SID][DID][L][DATA[]] (it excludes HEADER and CS)

SID = msg(1) ;
DID = msg(2) ;
L = msg(3) ;
if (L>20), return ;  end ; %suspicious message

time = double(t_cx(1))/10000 ;  % timestamp , in expressed seconds
data = msg(4:4+L-1);
fprintf('t=%.3f,cx=[%d],Sender=[%x],Dest=[%x],L=[%d],Data={',time, t_cx(2), SID, DID, L);
fprintf('%02x,',data); fprintf('}\n');
% what is inside data[] is your business
return ;
%....................................................

% ---------------- END of Program -------------------
% Jose Guivant - July/2012 - MTRN3100
% ----------------------------------------------


