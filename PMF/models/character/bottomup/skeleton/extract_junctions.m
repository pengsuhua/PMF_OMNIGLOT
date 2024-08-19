% Extract critical features (junctions and endpoints).
%
% Rougly follows procedure of Liu et al. "Identification of Fork Points..." IEEE
% TAPMI
%
% For a circular stroke, there are no "features" by this definition.
% Thus, for any partition of the pixels into regions, there should
% be at least one feature for the tracing algorithm to find.
%
% Input
%  T: [n x n boolean] thinned image.
%    images are binary, where true means "black"
%
% Output
%  SN: [n x n boolean] extracted features.
function SN = extract_junctions(T)

    SE = bwmorph(T,'endpoints');
    SB = T; % black pixels
    sz = size(T,1);  % 获取矩阵T的行数，并将其赋值给变量sz=105
    
    lutS3 = makelut( @(P)fS3(P) , 3);  %lutS3 =512 x1 的double,一些像素。  makelut函数将调用fS3函数，并将所有可能的3x3像素邻域作为输入参数P传递给fS3函数。fS3函数的作用是根据像素邻域P生成一个二进制码，表示对该像素进行形态学操作的操作类型和参数。用于生成形态学操作的查找表（lookup table）。
    S3 = applylut(T,lutS3);  % S3 = 105×105 logical 数组。打印出来可以看到：里面有些像素变为1了。虽然不知道具体怎么变的。这是内置函数。

    % final criteria
    SN = SE | (SB & S3);  % 将SB与S3进行逻辑与，再和SE进行逻辑或操作。得到SN。打印出来可以看到。SN里只是有一些像素是1了。感觉这些点就是所谓的交叉点和结束点了。
    
    % Check to see that each connected component has a feature.
    % This is necessary to process circles in the image.
    CC = bwconncomp(T,8); % 计算二值图像T中的连通区域。参数8表示采用8连通方式（8-connected）计算连通区域，即将每个像素的8个邻域都视为相邻像素。bwconncomp函数会将输入的二值图像T中的所有像素划分到不同的连通区域中，并将每个连通区域表示为一个结构体。该结构体包含了该连通区域的大小、像素坐标等信息
    nCC = CC.NumObjects; % nCC = 1
    for c=1:nCC
       
       pid = CC.PixelIdxList{c};       
       
       % We have a circle. Circles are generally drawn from the
       % top, we choose the top pixel here
       if sum(SN(pid))==0
          [irow,icol] = ind2sub(sz,pid);
          sel = argmin(irow);
          SN(pid(sel)) = true;           
       end
                      % 调用MATLAB内部的函数bwconncomp，计算输入的二值图像T中的连通区域，并将其表示为一个结构体CC。然后，程序遍历每个连通区域，并对其中的像素进行处理。对于每个连通区域，程序首先获取其像素索引列表（PixelIdxList），然后判断其中是否存在已经被标记的点，即SN矩阵中相应位置的值是否为1。如果存在已经被标记的点，则程序跳过该区域，继续处理下一个区域。
                      %如果该连通区域中不存在已经被标记的点，则程序计算该区域中所有像素的行坐标（irow），并选择其中最小值对应的像素作为最高点。程序将该像素的索引添加到SN矩阵中，并继续处理下一个区域。
    end
       
end

% See Liu et al.
function Y=fS3(P)
    sz = size(P);
    assert(isequal(sz,[3 3]));
    
    % Get cross number
    NC = fNC(P);
    
    % Count black pixels
    PM = P;
    PM(2,2) = false;
    NB = sum(PM(:));
    
    % Criteria
    Y = (NC >= 3-eps) || (NB >= 4-eps);
end

% See Liu et al.
function Y=fNC(P)       
    sum = 0;
    for i=0:7
        sum = sum + abs( P(fIP(i+1)) - P(fIP(i)) );
    end
    Y = sum./2;
end

% See Liu et al.
function newlindx = fIP(lindx)
    switch lindx
        case {0,8}
            i=1; j=2;
        case 1
            i=1; j=3;
        case 2
            i=2; j=3;
        case 3
            i=3; j=3;
        case 4
            i=3; j=2;
        case 5
            i=3; j=1;
        case 6
            i=2; j=1;
        case 7
            i=1; j=1;
    end
    newlindx = sub2ind([3 3],i,j);
end