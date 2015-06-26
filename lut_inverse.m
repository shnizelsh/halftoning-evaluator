
function [ inverted_lut ] = lut_inverse( LUT )
% This function gets a Lookup table (vector) and return an inverted Lookup table

LUT=uint8(LUT);
n=size(LUT,1);

% ensure weak increasing monotonic
for i=2:n
    % avoid zeros
    if(LUT(i-1)>LUT(i))
        LUT(i)=LUT(i-1)+1;
    end
end

M=zeros(n,1);
for i=0:n-1
    %find first j
    for j=1:n-1
    if(LUT(j)>i)
       M(i+1)=j-1;
       break;
    end
    end    
end

% ensure weak increasing monotonic
for i=2:n
    % avoid zeros
    if(M(i-1)>M(i))
        M(i)=M(i-1);
    end
end

M(1)=0;
M(n)=255;

plot(1:n,M(:),1:n,LUT(:));
inverted_lut=M;
end

