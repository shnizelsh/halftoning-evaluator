function  [score1,score2]=band_meter(profile,max_bands)
% max_bands - the maximum number of bands caused by banding distortion
% score1 - a score based on the gap between the maximum and the minumun of
% the power spectrum in the defined frequncy range.
% score 2 - a score based on the total energy in the defined frequency
% range

n=length(profile);
P=fft(profile);

filt=zeros(size(profile));
filt(1)=1;
center=find(fftshift(filt)); %finding the DC location
sP=fftshift(abs(P));
sP=sP(center-max_bands-1:center+max_bands+1);
a=min(sP);
sP(max_bands+2)=0;
b=max(sP);

score1= (b-a);
score2= sum(sP);


