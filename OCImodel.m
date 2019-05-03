noon_table = readtable('daily_noon.csv');
noon_gen = noon_table{:,3};
%Max power (kW) at noon for each month 
Dec_maxgen = max(noon_gen(1:31,:));
Nov_maxgen = max(noon_gen(32:61,:));
Oct_maxgen = max(noon_gen(62:92,:));
Sep_maxgen = max(noon_gen(93:122,:));
Aug_maxgen = max(noon_gen(123:153,:));
Jul_maxgen = max(noon_gen(154:184,:));
Jun_maxgen = max(noon_gen(185:214,:));
May_maxgen = max(noon_gen(215:245,:));
Apr_maxgen = max(noon_gen(246:275,:));
Mar_maxgen = max(noon_gen(276:306,:));
Feb_maxgen = max(noon_gen(307:334,:));
Jan_maxgen = max(noon_gen(335:365,:));
Pmax = [Jan_maxgen Feb_maxgen Mar_maxgen Apr_maxgen May_maxgen Jun_maxgen...
    Jul_maxgen Aug_maxgen Sep_maxgen Oct_maxgen Nov_maxgen Dec_maxgen];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_days = [31 28 31 30 31 30 31 31 30 31 30 31];
forward = flip(noon_gen); %flipping data to start from 1/1/18  
% OCI for each Day Of Month
DOM = 1;
for i=1:12
    month_end = num_days(i);
    for j=1:month_end
        Pday(i,j)= forward(DOM,1);
        DOM=DOM+1;
    end
end
% calculating daily OCI
% OCI(month,DOM), where month = 1->12 & DOM = 1-> N_thday
for i=1:12
    month_end = num_days(i);
    for j=1:month_end
        OCI(i,j) = 10 -((Pday(i,j)-(0.05*Pmax(i)))/(Pmax(i)-(0.05*Pmax(i)))*10);
    end
end
% Indexing OCI with day of the year
index_OCI = zeros(1,365);
counter = 1;
for m=1:12 
    for d=1:num_days(m)
        index_OCI(1,counter) = OCI(m,d);
        counter = counter+1;
    end
end
