function X=f_fft(x) %FFT Radix 2 DIT
    N=max(size(x));
    Log2dN=round(log2(N));
    GdMxEt=N/2;
    MxG=1;

    XRe = bitrevorder(real(x));
    XIm = bitrevorder(imag(x));
    X = bitrevorder(x);
    for Etn = 1:1:Log2dN
        k=1;
        for Gn=1:1:GdMxEt
            r=-GdMxEt;
            for Mn = 1:1:MxG
                aRe=XRe(k);
                aIm=XIm(k);
                bRe=XRe(k+MxG);
                bIm=XIm(k+MxG);
                r=r+GdMxEt;
                WNrRe=cos(2*pi*r/N);
                WNrIm=sin(2*pi*r/N)*-1;
                TRe = (bRe*WNrRe) - (bIm*WNrIm); % b * WNr Real
                TIm = (bRe*WNrIm) + (bIm*WNrRe); % b * WNr Imaginario
                XRe(k)=aRe + TRe; % a + b * WNr Real
                XIm(k)=aIm + TIm; % a + b * WNr Real Imaginario
                XRe(k+MxG)=aRe - TRe; % a - b * WNr Real
                XIm(k+MxG)=aIm - TIm; % a - b * WNr Real Imaginario
                k=k+1;
            end
            k=k+MxG;
        end
        GdMxEt = GdMxEt/2;
        MxG=MxG*2;
    end
X =  XRe + 1i * XIm;
end

