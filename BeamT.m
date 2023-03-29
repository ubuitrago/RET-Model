function value = BeamT(A,N,SolarAltitude)
% A should be given as the altitude in km. N is day of year with Jan 1 is
% N=1. Solar altitude should be given in degrees

if N < 80 || N > 354
    ro = 1.03;
    r1 = 1.01;
    rk = 1;
elseif (171 <= N)&& (N < 260) 
    ro = .97;
    r1 = .99;
    rk = 1.02;
else %I'm guessing that in the spring and fall the values are in the middle
    % of the summer and winter values.
    ro = 1;
    r1 = 1;
    rk = 1.01;
end
aoo = .4237 - .008216*(6-A)^2;
a1o = .5055 + .00595*(6.5-A)^2;
ko = .2711 + .001858*(2.5-A)^2;

ao = ro*aoo;
a1 = r1*a1o;
k = rk*ko;

if length(SolarAltitude)>1
    
    beamt = 0;

    for i = 1:length(SolarAltitude)
        if SolarAltitude(i)>0
            beamt(i) = ao + a1*exp(-k/cosd(90-SolarAltitude(i)));
        else
            beamt(i) = 0;
        end
    end
    value = beamt;
else
    value = ao + a1*exp(-k/cosd(90-SolarAltitude));
end