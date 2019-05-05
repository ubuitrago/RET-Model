load('Case1_integralPower_year.mat');
load('Case4_integralPower_year.mat');
load('PEC_2018_Kwh.mat');
load('Case1ANDcase5_year.mat');

figure
hold on;
plot(daily_power(1,:),'b-');
plot(daily_power(2,:),'r-');
plot(integration,'g-');
plot(integralP,'m-');
plot(PEC,'k--')
xlim([0 365]);
ylabel('Power Produced (MWh)')
xlabel('Day of year')
title('Total Daily Energy Production vs Day of the Year with complete model')
legend('Case 1 + Panel Temp. Model','Panel Temp. Model + Cloud Model','Case 1'...
    ,'Case 4','PEC actual data')
set(legend,'Location','southoutside','FontSize',12);