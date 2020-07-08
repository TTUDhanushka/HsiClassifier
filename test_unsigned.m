

meter_value = 15465;

Pow = 1;

for D = 1:15
    Pow = 10 ^ D
    update_val =  meter_value / Pow
    
    if update_val < 1  
        num_digits = D
        break

    end
    
end

  