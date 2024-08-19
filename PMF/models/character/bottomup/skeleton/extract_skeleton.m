%
% Compute a bottom-up character skeleton.
% This algorithm should be deterministic.
%
% Input
%  I: [N x N] binary image (true = black)
%  bool_viz: visualize the results? (default = true)
%
%  Z: [struct] graph structure
%    fields
%    .n: number of nodes
%    .G: [n x 2] node coordinates
%    .E: [n x n boolean] adjacency matrix
%    .EI: [n x n cell], each cell is that edge's index into trajectory list
%         S. It should be a cell array, because there could be two paths
%    .S: [k x 1 cell] edge paths in the image 
%
function U = extract_skeleton(I,bool_viz)
    
    if ~exist('bool_viz','var')
        bool_viz = false;
    end
    
    assert(UtilImage.check_black_is_true(I));
    
    T = make_thin(I); % get thinned image  》》T是一个105 x 105的logical数组，是一个将原始二值图像细化后的二值图像。细化的意思在我看来就是：保留注意足以表示图片特征的像素点，其他的像素点变为0.调试的时候，打印T，J就可以看到这二者的区别。
    %ind=find(T==1);
    %convertImageToPointCloud(T);

    
    J = extract_junctions(T); % get endpoint/junction features of thinned image  》》J是一个105 x105 的一个logical 数组。经过exteact_junctions操作后，只有其中的交叉点和终点的像素的logistic值为1，其他的都为0。
    U = trace_graph(T,J,I); % trace paths between features
    B = U.copy();
    U.clean_skeleton;  % 确实可以打印B，U，发现其中的属性n由原来的 9 变为了 7 。说明融合了一个点。
    
    if bool_viz
       sz = [313 316]; % figure size      
       h = figure;
       pos = get(h,'Position');
       pos(3:4) = sz;
       set(h,'Position',pos);
       
       % visualize original image
       subplot(2,2,1);
       viz_skel.plot_image(I);
       title('Image');
       
       % visualize thinned image
       subplot(2,2,2);
       viz_skel.plot_junctions(T,J); 
       title('Thinned');
       
       % visualize paths in thinned image
       subplot(2,2,3);
       B.plot_skel;
       title('Graph (raw)');
       
       subplot(2,2,4);
       U.plot_skel;
       title('Graph (cleaned)');
       
       set(gcf,'Position',pos);
       pause(0.01);   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   pause(.01);
       drawnow
    end
    
end

% Apply thinning algorithm. First it closes holes
% in the image.
%
% Input
%  I: [n x n boolean] raw image.
%    images are binary, where true means "black"
%
% Output
%  T: [n x n boolean] thinned image.
function T = make_thin(I)
    I = bwmorph(I,'fill');   % I = 105×105 logical 数组.   bwmorph函数中的'fill'参数表示进行填充操作，即将所有被白色像素包围的黑色像素填充为白色。消除二值图像中的孔洞和空洞，使得图像中的白色区域更加连通。
    T = bwmorph(I,'thin',inf);
end