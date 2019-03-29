function value = DiffuseT(BeamT)

for i=1:length(BeamT)
    if BeamT(i) <= 0
        value(i) = 0.00;
    else
        value(i) = 0.271 - 0.294*BeamT(i);
    end
end