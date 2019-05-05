close all
clear all
N = 85;                 %march 26
global TOD;

OCI=0;
x=4;
if x==4
    Ptot1 = P2_C6_Helper(N,OCI,46);
    %                (DOY,OCI,beta angle)
    Ptot2 = P2_C6_Helper(N,OCI,0);
    Ptot3 = P2_C6_Helper(N,OCI,0);
    Ptot4 = P2_C6_Helper(N,OCI,23);
end
if x==6
    Ptot1 = P2_C6_Helper(N,OCI,46);
    %                (DOY,OCI,beta angle)
    Ptot2 = P2_C6_Helper(N,OCI,0);
    Ptot3 = P2_C6_Helper(N,OCI,0);
    Ptot4 = P2_C6_Helper(N,OCI,23);
    Ptot5 = P2_C6_Helper(N,OCI,23);
    Ptot6 = P2_C6_Helper(N,OCI,46);

end
Ptot=zeros(1,289);
%%% adding up P totals
for i=1:length(Ptot)
    if x==6
        Ptot(i)=Ptot1(i)+Ptot2(i)+Ptot3(i)+Ptot4(i)+Ptot5(i)+Ptot6(i);
    end
    if x==4
        Ptot(i)=Ptot1(i)+Ptot2(i)+Ptot3(i)+Ptot4(i);
    end
end

consume = load('winter_consumption.mat');

%%%%%%%%%%%
%Grahping for case 6
%%%%%%%%%%%
figure
grid on
plot(TOD,Ptot,'-b');
title("4x System Power Delivery vs. Time of Day w/ Heat Transfer Model & OCI");
xlabel("Time of Day (Decimal Hours)");
ylabel("Total Power Delivery (MW)");
legend('March 26')
set(legend,'Location','southoutside','FontSize',12);
hold off


%%%%%%%%%%%%%%%%%%%