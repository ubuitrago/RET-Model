function value = findMonth(day)

if day>=1 && day<=31 %jan
    value=1;
elseif day>=32 && day<=59 %feb
    value=2;
elseif day>=60 && day<=90 %mar
    value=3;
elseif day>=91 && day<=120 %apr
    value=4;
elseif day>=121 && day<=151 %may
    value=5;
elseif day>=152 && day<=181 %june
    value=6;
elseif day>=182 && day<=212 %july
    value=7;
elseif day>=213 && day<=243 %aug
    value=8;
elseif day>=244 && day<=273 %sep
    value=9;
elseif day>=274 && day<=304 %oct
    value=10;
elseif day>=305 && day<=334 %nov
    value=11;
elseif day>=335 && day<=365 %dec
    value=12;
end