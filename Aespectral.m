%*******************************************************************
%           Lectura de una x[n] = xc(nT) en archivo.txt
%*******************************************************************
fid1=fopen('xne4.txt','r');
fid2=fopen('yn.txt','r');
xn = fscanf(fid1,'%f');
yn = fscanf(fid2,'%f');
fclose(fid1);
fclose(fid2);
Fs = 32000; %se debe sacar de antemano
Ts = 1/Fs;
%*******************************************************************
%           Análisis espectra de x[n] mediante la DFT (via la FFT)
%*******************************************************************
N = 2^12;
t1=2;
n1=round(t1*Fs);
n2=n1+N-1;

f0= Fs/N;
k= 0:1:N-1;
fk = k*f0;

win = window(@blackmanharris,N);
cg = sum(win)/N;

xwin = xn(n1+1:n2+1).*win;
Xwin = f_fft(xwin);
Ak = (2/N)*abs(Xwin);
Ak = (1/cg)*Ak;

ywin = yn(n1+1:n2+1).*win;
Ywin = f_fft(ywin);
Bk = (2/N)*abs(Ywin);
Bk = (1/cg)*Bk;
%*******************************************************************
%                           Graficas
%*******************************************************************
figure
subplot(2,2,1)
plot((n1:n2)*Ts, xn(n1+1:n2+1))
title('x[n]wrec[n]')
subplot(2,2,3)
stairs(fk, 20*log10(Ak))
xlim([0, Fs/2])
ylim([-110,0])
str = sprintf('20log( A(fk) ), Fs=%.0f, N=%.0f, t1=%.2f',Fs,N,t1);
title(str)
subplot(2,2,2)
plot((n1:n2)*Ts, yn(n1+1:n2+1))
title('y[n]wrec[n]')
subplot(2,2,4)
stairs(fk, 20*log10(Bk))
xlim([0, Fs/2])
ylim([-110,0])
str = sprintf('20log( B(fk) ), Fs=%.0f, N=%.0f, t1=%.2f',Fs,N,t1);
title(str)
%*******************************************************************
%                     Reproducción de X[n]
%*******************************************************************
player1 = audioplayer(xn, Fs);
playblocking(player1);
%*******************************************************************
%*******************************************************************
%                     Reproducción de Y[n]
%*******************************************************************
player2 = audioplayer(yn, Fs);
playblocking(player2);
%*******************************************************************