clear all
global TOD;
integralP=zeros(1,365);
for N=1:365
    Ptot = P1_C1(N,46);
    integralP(N)=trapz(TOD,Ptot);
end
figure
plot(integralP)
xlim([0 365]);
ylabel('Power Produced (MWh)')
xlabel('Day of year')
title('Total daily energy production vs day of year')