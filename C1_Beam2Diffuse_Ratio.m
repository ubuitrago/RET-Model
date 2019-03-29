%Ratio of beam irradiance to diffuse irradiance vs. time of day on June 21
global irrB;
global irrD;
global TOD;

ratio = [zeros([1 length(irrB)])];

for i=1:length(irrB)
    ratio(i) = irrB(i)/irrD(i);
end

%plotting 
figure
grid on;
plot(TOD,ratio,'-b');
title("Ratio of Beam to Diffuse Irradiance for Austin vs. Time of day");
xlabel("Time of Day (decimal hours)");
ylabel("Ratio of Beam to Diffuse");
grid off;

