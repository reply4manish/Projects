clear
%The filters in Time Domain:
h0=[-0.125  0.25  0.75 0.25  -0.125];
g0=[0.5 1 0.5];
h1=[0.5 -1 0.5];
g1=[0.125 0.25 -0.75 0.25 0.125];



% freqz(h0);
% title('H0(w)')
 
% freqz(g0);
% title('G0(w)')

% freqz(h1);
% title('H1(w)')


freqz(g1);
title('G1(w)')
