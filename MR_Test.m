clc;
clear all;
% ---- Sounds ---

xfilename = 'traffic-vehicles.wav';
nBits = 16;
[y, Fs] = audioread(xfilename);
%
info = audioinfo(xfilename);
audio_duration = info.Duration; % total time span of audio signal
[xhour0, xmin0, xsec0, x1_time_in_seconds] = current_clock();
%
sound(y, Fs, nBits);
%
data1 = x1_time_in_seconds;
disp(data1);
%
d2  = x1_time_in_seconds + audio_duration;
disp(d2);
display(d2-x1_time_in_seconds)
%
xmsg = [ 'Tempo 0:', num2str(x1_time_in_seconds),' Ate:', num2str(d2)];
disp(xmsg);
xd = x1_time_in_seconds;
while xd < d2
    [xhour1, xmin1, sec_now, xd] = current_clock();
    xmsg = [ 'Tempo now:', num2str(sec_now)];
  % disp(xd);
end    
clear sound;
xmsg = ['Play again: ', num2str(xd)];
disp(xmsg);
sound(y, Fs, nBits);

%%
xfilename = 'traffic-vehicles.wav';
playerObj = getplayer(xfilename);
play(playerObj);
xx = isplaying(playerObj);

%clear sound;
%%  new test
for k=1:4;
    t=[1/8000:1/8000:2];
    y=sin(2*pi*440*t)+sin(2*pi*480*t);
    sound(y,8000)
    pause(4)
end
%%
[xhour0, xmin0, xsec0, x1_time_in_seconds] = current_clock();
%%
rng(2,'multFibonacci');
s=randi([1 4], 1 , 10);
disp(s);