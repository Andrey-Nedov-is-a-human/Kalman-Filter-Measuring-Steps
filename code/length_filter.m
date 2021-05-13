function [zerovel] = length_filter(zerovel)    

    N = length(zerovel);

    freq_arr = zeros(1,1000);
    line_count = 0;
    counter = 0;
    turn = 0;

    for i=1:N
        if(zerovel(i) == 1)
            turn = 1;
            counter = counter + 1;
        else
            if(turn == 1)
                turn = 0;
                line_count = line_count + 1;
                freq_arr(line_count) = counter;
                counter = 0;
            end
        end
    end

    freq_arr(1) = 0;
    freq_arr(N) = 0;
    freq_arr_v = nonzeros(freq_arr);
    freq_hist = zeros(1, max(freq_arr_v));
    freq_count = 0;

    size(freq_arr_v)

    for i=1:max(freq_arr_v)
        for j=1:size(freq_arr_v)
            if(freq_arr_v(j)==i)
                freq_count = freq_count + 1;
            end
        end
        freq_hist(i) = freq_count;
        freq_count = 0;
    end

    freq_hist = integration(freq_hist);
    
    %figure;
    %plot(freq_hist);
    
    pic = 0;
    max_freq = max(freq_hist);
    up = 0;
    
    for i=1:length(freq_hist)
        if(freq_hist(i) >= max_freq/2)
            if(up == 0)
                pic = pic + 1;
                up = 1;
            end
        else
            up = 0;
        end
    end
    
    logic = pic > 1;
    
    if(pic > 1)
        cl_counter = 0;
        cl_index = 0;
        cl_true = 0;

        for i=1:N
            if(zerovel(i) == 1)
                if(cl_true == 0)
                    cl_true = 1;
                    cl_index = i;
                    cl_counter = 0;
                end
                cl_counter = cl_counter + 1;
            else
                if(cl_true == 1)
                    cl_true = 0;
                    if(cl_counter < length(freq_hist)/2)
                        for j=cl_index:i
                            zerovel(j) = 0;
                        end
                    end
                end
            end
        end
        zerovel = filter_1_2_3(zerovel);  
    end
end