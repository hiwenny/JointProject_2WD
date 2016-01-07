function [] = driveSquare(turn)


sideLength = 716.85;
turnLength = 35.45;

api = iniApiMTRN3100();

%Error Checking
if api.Ok < 1,
    fprintf('API not ok\n');
    return;
end

%First Side
api.PushMTRN3100Msg(1, [3, sideLength, sideLength], 170, 187);

%First Turn
api.PushMTRN3100Msg(1, [3, (turn * turnLength), (-turn * turnLength)], 170, 187);

%Second Side
api.PushMTRN3100Msg(1, [3, sideLength, sideLength], 170, 187);

%Second Turn
api.PushMTRN3100Msg(1, [3, (turn * turnLength), (-turn * turnLength)], 170, 187);

%Third Side
api.PushMTRN3100Msg(1, [3, sideLength, sideLength], 170, 187);

%Third Turn
api.PushMTRN3100Msg(1, [3, (turn * turnLength), (-turn * turnLength)], 170, 187);

%Fourth Side
api.PushMTRN3100Msg(1, [3, sideLength, sideLength], 170, 187);

%Final Turn
api.PushMTRN3100Msg(1, [3, (turn * turnLength), (-turn * turnLength)], 170, 187);

beep on;
i = 0;
for i= i:1:6,
api.PushMTRN3100Msg(1, [6, 29], 170, 187);
pause(2);
api.PushMTRN3100Msg(1, [6, 13], 170, 187);
pause(2);
end
beep off;
