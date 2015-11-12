function b = daughter(ang, sgn, scale)
% ang - angle (| = 0, / = 1, _ = 2, \ = 3)
% sgn - sign (even = 0, odd = 1)
% scale - as power of 3: 3^scale

if ang == 0 && sgn == 0
    b = 0;
elseif ang == 0 && sgn == 1
    b = 0;
elseif ang == 1 && sgn == 0
    b = 0;
elseif ang == 1 && sgn == 1
    b = 0;
elseif ang == 2 && sgn == 0
    b = 0;
elseif ang == 2 && sgn == 1
    b = 0;
elseif ang == 3 && sgn == 0
    b = 0;
elseif ang == 3 && sgn == 1
    b = 0;
end

if scale > 0
    b = b; % use repelem
end

if sgn == 0
    b = b/sqrt(18);
else
    b = b/sqrt(6);
end

end
