% Extract all the paths between nodes.
%
% Input
%  T: [n x n boolean] thinned image.
%    images are binary, where true means "black"
%  J: [n x n boolean] critical features (junctions
%    and endpoints)
%  I: [n x n boolean] original image
%
% Output
%  U: graph structure
%    fields
%    .n: number of nodes
%    .G: [n x 2] node coordinates
%    .E: [n x n boolean] adjacency matrix
%    .EI: [n x n cell], each cell is that edge's index into trajectory list
%         S. It should be a cell array, because there could be two paths
%    .S: [k x 1 cell] edge paths in the image 
function U = trace_graph(T,J,I)
    
    Z = struct;
    Z.T = T;
    Z.J = J;
    Z.U = false(size(T)); % which pixels have been explained?     生成一个与输入二值图像T相同大小的全False矩阵。 105×105 logical 全 零 数组
    clear T J    
    
    % Get fork points for the junctions
    jindx = find(Z.J);    % 查找输入矩阵Z.J中非零元素的索引。 返回一个包含所有非零元素索引的向量
    [jx jy] = find(Z.J);   % x,y的索引坐标
    Z.NF = getforks(jx,jy,Z.T);     % 在二值图像Z.T中查找给定坐标(jx,jy)处的分叉点，并返回返回找到的分叉点坐标列表。
    
    % Set up adjacency graph
    S = [];
    n = length(jindx);  % n = 11
    G = [jx jy];  % G:交叉点坐标
    E = false(n);  % 11 x 11的全 0 矩阵
    EI = cell(n);   % 11 x 11的cell数组
    
    for i=1:n % for each feature
       
       % starting node
       start = [jx(i) jy(i)];           % 开始点坐标
       
       % try all branches
       blist = Z.NF{i}; % get all branching options
       nb = size(blist,1);
       for k=1:nb
          
          br = blist(k,:);
          
          if ~Z.U(lind(br,Z)) % If this branch isn't yet explained         lind(br,Z)是一个索引列表，用于获取矩阵Z.U中与给定边界点br相邻的所有像素的索引
             path = [start; br];  % path = [59,29;59,28]
             if Z.J(lind(br,Z))
                % criteria so each junction-to-junction is added once
                if lind(br,Z) > lind(start,Z), continue; end
             else
                Z.U(lind(br,Z)) = true;         % 用于将矩阵Z.U中与输入列表lind(br,Z)中的索引对应的元素标记为True，表示这些像素已经被访问过
                tabu = false(size(Z.T));        % 创建一个 105 x 105的全0矩阵
                tabu(lind(blist,Z)) = true; % tabu list, of all
                    % other branch points from that junction
                tabu(lind(start,Z)) = true;
                [path,Z] = continuepath(path,Z,tabu);      % 得到[path,z]。path : 22 x 2的double数组;  Z : 一个struct,里面有 T，J，U，NF
             end
          
             % Update adjacency matrix  更新邻接矩阵
             S = [S; {path}];
             finish = path(end,:); % 取出了 path里面的最后一个数组
             snode = i;
             fnode = find(jx==finish(1) & jy==finish(2));  % find函数，查找满足条件jx==finish(1) & jy==finish(2)的元素在向量jx中的索引，并将结果赋值给变量fnode
             E(snode,fnode) = true;  % 将E矩阵里的snode行fnode列的值赋值为1
             E(fnode,snode) = true;
             eiset1 = [EI{snode,fnode}; length(S)];
             if ~isequal(sort(eiset1(:),1,'ascend'),unique(eiset1(:)))
                error('weird'); 
             end
             eiset2 = [EI{snode,fnode}; length(S)];
             EI{snode,fnode} = eiset1;  % 这两行将EI这个cell数组的snode行fnode列和fnode行snode列的值变为了1
             EI{fnode,snode} = eiset2;
             
          end
       end
    end
    
    % Return graph structure
    U = UGraph(G,E,EI,S,I);      % UGraph - 属性:

                                             %G: [11×2 double]
                                             %E: [11×11 logical]
                                             %EI: {11×11 cell}
                                             %S: {16×1 cell}
                                             %I: [105×105 logical]
                                             %n: 11
                                             %imsize: [105 105]
                                             %link_ei_to_ni: [16×2 double]
                                              %list_mask: {6×1 cell}
end

% Make linear index
%
% Input
%  pts: [n x 2] points to convert (Rows)
function y = lind(pts,Z)
    y = sub2ind(size(Z.T),pts(:,1),pts(:,2));
end

% Get the neighbors for each fork point
function NF = getforks(jx,jy,T)
    n = length(jx);
    NF = cell(n,1);
    for i=1:n
       junc = [jx(i) jy(i)];
       NF{i} = getneighbors(junc,T);  
    end
end

% Continue following the path until you reach a junction
function [path,Z] = continuepath(path,Z,tabu)    
    next = path(end,:);
    while ~Z.J(lind(next,Z))
        next = pathstep(next,Z,tabu);   % 调用pathstep函数，传递所需的输入参数。该函数会根据输入的当前路径点next，计算其周围8邻域内的所有未被访问过的像素，并选择其中一个作为下一个路径点返回。如果周围没有未被访问过的像素，则函数会返回空值。将计算得到的下一个路径点赋值给变量next
        Z.U(lind(next,Z)) = true;
        path = [path; next];  % 得到了路径  :22 x 2的double数组
        
        % Make sure we can do a loop and return
        % to the start state
        tabu = false(size(tabu));
    end
    
    % Reset any junction to be true
    Z.U(Z.J) = false;
end

% Return all neighbors in the 3 x 3 grid,
% where present nodes are indicated in V
% 
function [neighbors,num] = getneighbors(indx,V)
    i=indx(1);
    j=indx(2);    
    sz = size(V);
    iteri = max(i-1,1):1:min(i+1,sz(1));
    iterj = max(j-1,1):1:min(j+1,sz(2));
    subI = V(iteri,iterj);
    subI(iteri==i,iterj==j) = false;    
    [onx,ony] = find(subI);
    neighbors = [vec(iteri(onx)) vec(iterj(ony))];
    num = size(neighbors,1);
end

% Find the next step in the path
function next = pathstep(curr,Z,tabu)

    [next,num] = getneighbors(curr,Z.T & ~Z.U & ~tabu);
    if num==0
       error('no neighbors to continue path'); 
    end
    
    % if there is more than on possibility
    if num>1
        
       % if possible, pick a joint point
       ind = lind(next,Z);
       isj = Z.J(ind);
       if any(isj) 
          next = next(isj,:);
       end
       
       % pick the closest candidate left
       dists = pdist2(curr,next,'cityblock');
       jindx = argmin(dists);
       next = next(jindx,:);
    end
    
end