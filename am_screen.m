

function [ htimage ] = am_screen( cmyk )
% A Simple implementation of AM screen halftone algorithm

rows=size(cmyk,1);
cols=size(cmyk,2);
rotate=false;
if(rows > cols)
    cmyk=imrotate(cmyk,90);
    rotate=true;
    temp = cols;
    cols=rows;
    rows=temp;
end
htimage=zeros(rows,cols,4);
c_cell = [   0 11 15  0  0
             0  5  6  7 13
            16  4  1  8 17
            12  3  2  9  0
             0  0 14 10 0 ]/17;

c_screen=create_screen(c_cell,rows,cols,[0 3],[1 -1],[0.6 0.6]);
htimage(:,:,1) = cmyk(:,:,1) > c_screen;

m_cell = [   0  0 15 11  0
            13  7  6  5  0
            17  8  1  4 16
             0  9  2 3  12
             0 10 14 0 0 ]/17;
m_screen=create_screen(m_cell,rows,cols,[-1 1],[3 0],[0.6 0.25]);
htimage(:,:,2) = cmyk(:,:,2) > m_screen;


y_cell = [   7  6  5  13 
             8  1  4  15  
             9  2  3  11              
             14 16 12 10 ]/16;
y_screen=create_screen(y_cell,rows,cols,[0 0],[4 0],[0.6 0.1]);
htimage(:,:,3) = cmyk(:,:,3) > y_screen;


k_cell = [   0  0 15  0  0
             0  8  6  5  0
            18  7  1  4 14
            16  9  2  3 13
             0 10 11 12  0
             0  0 17  0  0 ]/18;
k_screen=create_screen(k_cell,rows,cols,[ 0 0],[ 3 -2],[0.6 0.1]);
htimage(:,:,4) = cmyk(:,:,4) > k_screen;
   

if(rotate)
    htimage=imrotate(htimage,-90);  
end

end



function [ screen ] = create_screen( cell,rows,cols,tiling_vec_row,tiling_vec_col,crop_point )

n=size(cell,1);
m=size(cell,2);
factor=5;
screen=zeros(rows*factor,cols*factor);
% init

index=1;
offset=10;
from_r=offset+(index-1)*n+tiling_vec_row(1);
to_r=from_r+n-1;
while(to_r <rows*factor)
    from_r=offset+(index-1)*n+tiling_vec_row(1);
    from_c=offset+(index-1)*tiling_vec_row(2);
    to_r=from_r+n-1;
    to_c=from_c+m-1;
    
    while(to_c < cols*factor && to_r <rows*factor)
        try
        screen(from_r:to_r,from_c:to_c)=screen(from_r:to_r,from_c:to_c)+cell;
        catch
        disp('err');
        end
        from_c=from_c+m+tiling_vec_col(2);
        from_r=from_r+tiling_vec_col(1);
        to_r=from_r+n-1;
        to_c=from_c+m-1;
    end
    index=index+1;
    from_r=offset+(index-1)*n+tiling_vec_row(1);
    to_r=from_r+n-1;
end

from_row=floor(rows*factor*crop_point(1));
from_col=floor(cols*factor*crop_point(2));

screen=screen(from_row+1:from_row+rows,from_col+1:from_col+cols);




end
