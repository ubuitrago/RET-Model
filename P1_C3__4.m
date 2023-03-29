clear all
Tiltbest=zeros(365,289);
for N = 1:365
    global TOD;
    long_std = 90; %standard longitude 
    long_loc = 97.753; %local longitude
    TOD = [0.00:5/60:24.00]; % Decimal Hours 
    ST = [zeros([1 length(TOD)])]; % pre-filled for execution speed 
    et = ET(N); % equation of time

    for i=1:length(TOD)
        ST(i) = solar_time(TOD(i),long_std,long_loc,et);
    end
    %solar altitude
    lat = 30.260; % Austin latitude 
    dec = Declination(N); % angle in degrees 
    Alpha = [zeros([1 length(TOD)])]; %solar altitude 
    hrAng = [zeros([1 length(TOD)])]; %hour angle 
    for i=1:length(TOD)
        hrAng(i) = w(ST(i));
        Alpha(i) = SolarAltitude(lat,dec,hrAng(i));
    end
    %%%%%%%%%%
    % finding the best tilt angle
    %%%%%%%%%%
    io = Io(N);
    Tiltrange = -90:1:90;
    for j = 1:length(TOD)
        for i = 1:length(Tiltrange)
            incident(i,j) = Incident(Alpha(j), Tiltrange(i), SolarAzimuth(Alpha(j),dec,hrAng(j)), 46);
        end
    end

    [incidentbest, indexbest] = min(incident,[],1);
    Tiltbest(N,:) = indexbest-91;
end
integralP=zeros(1,365);
for N=1:365
    Ptot = P1_C3(N,Tiltbest(N,:));
    integralP(N)=trapz(TOD,Ptot);
end
figure
plot(integralP)
grid on
xlim([0 365]);
ylabel('Power Produced (MWh)')
xlabel('Day of Year')
title('Total Daily Energy Production vs Day of Year')