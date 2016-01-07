% notes:
% Did:
% - put graph onto figure
% - labelled graph
% - labelled functions
% - set id 170 and 187 AA and BB
% - got graph to work
% - created new global "BUFFER" to interact with processor function

% Need to do:
% - need to implement all commands
% - need to make all buttons functinal
% - change name of functions, Jose sounds annoying, and make structure more
% logical more me
% - make buttons coloured to look cool

% Example for implementing a basic GUI for sending messages through the
% comm link, setting global flags, etc,etc.
% --------------------------------------------------------------
function main()
global SomeUsefulTHings BUFFER;

SomeUsefulTHings.API =  iniApiMTRN3100();
if SomeUsefulTHings.API.Ok<1, return ; end;          % if Not OK, ends this program..

SomeUsefulTHings.MyID =170; %0xAA in dec
SomeUsefulTHings.MyArduinoID =187; %0xBB in dec

SomeUsefulTHings.FlagDoBye=0;
SomeUsefulTHings.FlagDoPLot=0;

CreateSomeControlPanel();
initatebuffer();
for i=1:10000, % might need to change stuff here
    BUFFER = processor(SomeUsefulTHings.API.GetMTRN3100Msg(1,10), BUFFER);
    pause(0.2);
end;
return ;
 
%..............................................................

function Callback1(a,b) % Stop / Continue button
global SomeUsefulTHings ;
SomeUsefulTHings.FlagDoPLot=~SomeUsefulTHings.FlagDoPLot;
fprintf('Flag Run =[%d]\n',SomeUsefulTHings.FlagDoPLot);
if SomeUsefulTHings.FlagDoPLot == 1,
    SendThisData([00,255]);%stop command
else
    SendThisData([00,05])%continue command
end;
% you may send messages to your Arduino program from here or from other controls' callback functions.....
return;

% function QUIT(a,b) %
%     global SomeUsefulTHings ;    
%     SomeUsefulTHings.FlagDoBye=1;
% return;

% function Callback3(a,b) %BLABLA 3
% disp('(3) something to do here....');
% 
% return;

function SendThisData(data) % Send Message
    global SomeUsefulTHings;
    SomeUsefulTHings.API.PushMTRN3100Msg(1,data,SomeUsefulTHings.MyID , SomeUsefulTHings.MyArduinoID );
    fprintf('sending : = [%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x',data );
    fprintf(']\n');
    fprintf('in HEX  : = [%d %d %d %d %d %d %d %d %d %d', data);
    fprintf(']\n');
return;

function CallbackForAceptingEditBox(a,b)
    global SomeUsefulTHings ;    
    CurrentEditBoxText = get(SomeUsefulTHings.HandleEditBox1,'String');
    v  =str2num(CurrentEditBoxText);
   
    if numel(v)>0;
        SendThisData(v);
    else, fprintf('Numerical value in the Edit BOX is INVALID\n');  end;

return;

function CallbackEditBox(a,b) %when you press enter on edit box
disp('Event in Edit BOX1'); %text content has been modified.
% this callback function is executed when the EDIT BOX lose the focus (i.e.
% you finished editing its text...
return;

function CallbackListBox1(a,b) % drop box
global SomeUsefulTHings;

value = get(a,'value');
str = char(SomeUsefulTHings.ListBox1Items(value));
fprintf('You selected item (%d) = [%s]\n',value,str);

switch (value)
    case 1
        SendThisData([00,255]); % stop
    case 2        
        SendThisData([00,254]);  % slow
%     case 3
%         disp('something to do here...');
end;    

return;
% here we create some controls in a different figure.
function CreateSomeControlPanel()
global SomeUsefulTHings BUFFER;  
% str = '00 - Sample Rate';
str = strvcat('00-Sample Rate','04-Analog Output','05-Multiple Analog Output','06-Digital Output','07-Echo') %should be two lines
figure('Name','Arduino Window'); clf;
cy = 10; 
uicontrol('Style','pushbutton','String','Continue / Stop','Position',[10,cy,100,35], 'Callback',@Callback1);   
cy = cy + 40; 
% uicontrol('Style','pushbutton','String','QUIT ','Position',[10,cy,100,35], 'Callback',@QUIT);   
cy = cy + 40;
uicontrol('Style','text','String',str,'Position',[10,250,115,100]);
% uicontrol('Style','pushbutton','String','BLABLA 3','Position',[10,cy,100,35], 'Callback',@Callback3);   
cy = cy + 40+10; 
SomeUsefulTHings.HandleEditBox1=uicontrol('Style','edit','String','100,200,123','Position',[10,cy,150,35],'Callback',@CallbackEditBox);
cy = cy + 36; 
uicontrol('Style','pushbutton','String','Send Message','Position',[10,cy,100,35], 'Callback',@CallbackForAceptingEditBox);   
cy = cy + 40; 
SomeUsefulTHings.ListBox1Items = { 'Send Stop' , 'Send continue'}; % , 'ETC1' 
hl=uicontrol('Style','popupmenu','String',SomeUsefulTHings.ListBox1Items,'Position',[10,cy,170,35], 'Callback',@CallbackListBox1);   

% really basic graph - need to move position
subplot(1,2,2); hold on ;
BUFFER.hp1 = plot(0,'b');
BUFFER.hp2 = plot(0,'r');
BUFFER.hp3 = plot(0,'g');
get(hl)
return;

% -------------------------------------------------------------------------
function initatebuffer()
    global BUFFER;
    BUFFER.L=200;
    BUFFER.Data=zeros(2,BUFFER.L);
    BUFFER.index=1;
    %figure(1) ;clf ; hold on ; old run 1 function
    BUFFER.c=1;
return;

