% Daily energy production vs. DOY with cloud model
clear all
global TOD;
load('DailyOCI.mat');
num_days = [31 28 31 30 31 30 31 31 30 31 30 31];
DOY = [1:1:365];
integralP = zeros(1,365);

for N=1:365
    Ptot = P2_C4(N,index_OCI(N));
    integralP(N)=trapz(TOD,Ptot);
end

plot(DOY,integralP);
xlim([0 365]);
ylabel('Power Produced (MWh)')
xlabel('Day of year')
title('Total Daily Energy Production vs Day of the Year with OCI model')
    