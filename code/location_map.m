function [LM_len I] = location_map(I)
[d1 d2] = size(I);
d1 = d1-2;
d2 = d2-2;
map = [];
for i=1:d1
    for j=1:d2
        if I(i,j) == 255
            I(i,j) = 254;
            map = [map 1];
        elseif I(i,j) == 0
            I(i,j) = 1;
            map = [map 1];
        elseif I(i,j) == 254
            map = [map 0];
        elseif I(i,j) == 1
            map = [map 0];
        end
    end
end

cPos_x = cell(1,1);%À„ ı±‡¬Î—πÀı
cPos_x{1} =map;
loc_Com =  arith07(cPos_x);
bin_index = 8;
[bin_LM, LM_len] = dec_transform_bin(loc_Com, bin_index);

end