function z= remakeTrial(dtally,dist)
    %consider task and distrators, reissue what happened that trial
    behav = find(dtally(2:end));
    dstim = find(dist);
    z = zeros(1,4);
    if behav<3 && dstim == 1 %easy hit/miss
        z=dtally;
    elseif behav<3 && dstim ==2 %hard hit/miss --> transpose to hard CR/FA
        if behav ==1 %hit becomes a H-FA
            z(4) =1;
        elseif behav ==2 %miss becomes a H-CR
            z(3) =1;
        end
        z=[1,z]; %pad z with a 1 for tally
    elseif behav>2 && dstim == 2 % easy cr/fa
        z = dtally;
    elseif behav>2 && dstim == 1 % hard cr/fa --> transpose to hard hit/miss
        if behav == 3 %cr becomes H-miss
            z(2) = 1;
        elseif behav ==4 %fa becomes H-hit
            z(1) = 1;
        end
        z=[1,z];
    end
    
end