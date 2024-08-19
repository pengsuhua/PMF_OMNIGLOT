%
%  Map a sequence of pen points into a Motor Program
%
%  Input
%   S: [ns x 1 nested cell array] of trajectories in motor space [n x 2]
%   I: [binary image]
%   fclassify: [function handle] fclassify([n x 2] trajectory, [scalar]
%                                   scale)
%               this function classifies trajectories are belong to a
%               specific library component
%
%  Output
%   M: MotorProgram object
%
function M = sequence_to_MP(S,I,fclassify,lib)

    assert(iscell(S));
    assert(iscell(S{1}));

    % find the new scale of primitives
    assert(exist('lib','var')>0);
    newscale = lib.newscale;
    ncpt = lib.ncpt;
    
%     % find the new scale of primitives
%     ps_clustering = defaultps_clustering;
%     newscale = ps_clustering.newscale_ss;
%     ncpt = ps_clustering.ncpt;
%     if exist('lib','var')
%        newscale = lib.newscale;
%        ncpt = lib.ncpt;
%     end
    
    % get the normalized trajectories, the stroke centers, scales, etc.
    verbose = false;
    [S_norm,~,S_scales] = normalize_dataset(S,newscale,verbose);    % 归一化数据集
    
    % fit splines to the normalized trajectories, and assign them
    % indices in the library  将样条曲线拟合到归一化轨迹，并指定它们在库中的索引
    PM = defaultps;
    ps_bottomup = defaultps_bottomup;
    ns = length(S);
    S_splines = cell(ns,1);  % 4 x 1的一个空的cell数组
    for sid=1:ns         
        nsub = length(S{sid});
        S_splines{sid} = cell(nsub,1);
        for b=1:nsub
            S_splines{sid}{b} = fclassify(S_norm{sid}{b},S_scales{sid}{b});   % 调用 fclassify = @(traj,scale) classify_traj_as_subid(traj,scale,lib)里的 classify_traj_as_subid函数
        end
    end

    % make motor program structure
    M = MotorProgram(ns);
    M.I = I; % set the image
    M.parameters = PM;
    for sid=1:ns % for each stroke
       nsub = length(S{sid}); 
       M.S{sid}.ids = []; %zeros(nsub,1);
       M.S{sid}.invscales_token = zeros(nsub,1);
       M.S{sid}.angles_token = zeros(nsub,1);
      
       
       M.S{sid}.shapes_token = zeros(ncpt,2,nsub);   %%%%%如果要是改这里ncpt,下面就不用改。但是这个ncpt我找不到如何改？
       
       for b=1:nsub % for each sub-stroke
          M.S{sid}.ids(b,:) = S_splines{sid}{b}.indx;
          M.S{sid}.invscales_token(b) = 1 ./ S_scales{sid}{b}(1);
          M.S{sid}.angles_token(b) = 0.0;
          
          len = length(S_splines{sid}{b}.bspline);   %%%%%更改处。
          
          M.S{sid}.shapes_token(1:len,:,b) = S_splines{sid}{b}.bspline;
          %原来是：M.S{sid}.shapes_token(:,:,b) = S_splines{sid}{b}.bspline;
       end
       M.S{sid}.invscales_type = M.S{sid}.invscales_token;
       
       M.S{sid}.pos_token = S{sid}{1}(1,:); % start position in real trajectory     
    
    end    
    
    % initialize the noise parameters
    M.epsilon = ps_bottomup.init_epsilon;
    M.blur_sigma = ps_bottomup.init_blur_sigma;
    
end