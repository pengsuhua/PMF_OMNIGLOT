% Mostly bottom-up method for generating a set
% of good candidate parses to optimize further.
%
% Input
%  I: [n x n bool] binary image
%  lib: library
%  ninit: number of parses to choose
%  verbose: true/false
%
% Output
%  bestMP: [ninit x 1 cell] list of best candidate motor programs
%  score_sorted: [n x 1] score of all parses considered in sorted order
%
function [bestMP,score_sorted] = generate_random_parses(I,lib,ninit,verbose)
    if ~exist('verbose','var')
       verbose = false; 
    end    

    % Check that image is in the right format    
    assert(UtilImage.check_black_is_true(I));   % 检查输入的二值图像I中，黑色像素的取值是否为真（即1），如果是，则返回true（真），否则返回false（假）。
    
    % If we have a blank image
    if sum(sum(I))==0  % 因为二值图像中像素值只有0和1，所以对二值图像进行sum操作等价于计算二值图像中1的像素数量。
       bestMP = [];
       return
    end
    
    % Get character skeleton from the fast bottom-up method
    G = extract_skeleton(I,verbose);
    
    % Create a set of random parses through random walks
    ps = defaultps_bottomup;
    if verbose, fprintf(1,'\ngenerating random walks...\n'); end
    RW = RandomWalker(G);
    PP = ProcessParses(I,lib,verbose);
    
    % Add deterministic minimum angle walks
    for i=1:ps.nwalk_det    % ps.nwalk_det = 5
        PP.add(RW.det_walk);  % 将一个名为RW.det_walk的对象添加到PP对象中，使用MATLAB中的add方法。
    end
    
    % Sample random walks until we reach capacity.    使用随机游走算法（Random Walk，简称RW）生成一组笔画路径，并将这些路径添加到一个名为PP的对象中，直到达到一定数量的笔画或笔画路径长度。
    walk_count = PP.nwalks;
    while (PP.nl < ps.max_nstroke) && (walk_count < ps.max_nwalk)
        list_walks = RW.sample(1);
        PP.add(list_walks{1});
        walk_count = walk_count + 1;
        if verbose && mod(walk_count,5)==0
            fprintf(1,'%d,',walk_count);
            if mod(walk_count,20)==0
               fprintf(1,'\n'); 
            end
        end
    end
    if verbose, fprintf(1,'done.\n'); end
        
    % Turn parses into motor programs with additional search 
    % and processing
    [bestMP,score_sorted] = parses_to_MPs(I,PP,ninit,lib,verbose);
    
end