clear all
integralP=zeros(1,365);
for N=1:365
    Ptot = P1_C1(N);
    integralP(N)=sum(Ptot);
end
plot(integralP)
xlim([0 365]);
ylabel('Power Produced (MWh)')
xlabel('Day of year')
title('Total daily energy production vs day of year')