%
% Plot a motor trajectory on top of the image
%
% Input
%   I [105 x 105] image (double or binary) (large numbers are BLACK)
%   drawings: [nested cell] of strokes in motor space
%   size_start : [scalar] size of start marker
%   lw : line widht of stroke
function plot_motor_to_image(I,drawing,size_start,lw)   % plot_motor_to_image函数接受四个输入参数：图像I、手写笔画的运动轨迹drawing、起始点的大小size_start和线段的宽度lw。该函数的主要功能是将手写笔画的运动轨迹转换为图像坐标系，并在图像上绘制出所有笔画的轨迹。该函数还可以通过输入参数控制是否显示起始点和笔画编号，以及起始点和笔画编号的大小。

    if ~exist('size_start','var') || isempty(size_start) 
       size_start = 18;
    end
    bool_start = size_start > 0;
    if ~exist('lw','var') || isempty(lw)
       lw = 4; % line width 
    end

    assert(size(I,1)==105);
    assert(size(I,2)==105);
    drawing = space_motor_to_img(drawing);
    hold on
    plot_image_only(I);
    
    % Draw each stroke
    ns = length(drawing);
    for i=1:ns
        stroke = drawing{i};
        nsub = length(stroke);
        color = get_color(i);
        for b=1:nsub
            plot_traj(drawing{i}{b},color,lw);
        end
    end
    
    % Plot sub-stroke breaks
    if bool_start
        for i=1:ns
            stroke = drawing{i};
            nsub = length(stroke);
            color = get_color(i);
            for b=1:nsub
                plot_break(drawing{i}{b},size_start);
            end
        end
    end
    
    % Plot starting locations and stroke order markers
    if bool_start
        for i=1:ns
            stroke = drawing{i};
            plot_start_loc(stroke{1}(1,:),i,size_start);
        end
    end
      
    set(gca,'YDir','reverse','XTick',[],'YTick',[]);
    xlim([1 105]);
    ylim([1 105]);
end

function plot_traj(stk,color,lw)  % plot_traj函数接受三个输入参数：笔画的轨迹stk、轨迹的颜色color和线段的宽度lw。该函数的主要功能是将笔画的轨迹绘制为线段，并设置线段的颜色和宽度。
    ystk = stk(:,2);
    stk(:,2) = stk(:,1);
    stk(:,1) = ystk;       
    plot(stk(:,1),stk(:,2),'Color',color,'LineWidth',lw);
end

function plot_break(stk,size_start)   %plot_traj函数接受三个输入参数：笔画的轨迹stk、轨迹的颜色color和线段的宽度lw。该函数的主要功能是将笔画的轨迹绘制为线段，并设置线段的颜色和宽度。
    ystk = stk(:,2);
    stk(:,2) = stk(:,1);
    stk(:,1) = ystk;       
    plot(stk(end,1),stk(end,2),'MarkerEdgeColor','k','Marker','o','MarkerFaceColor','w','MarkerSize',size_start/2) 
end

% Plot the starting location of a stroke
%
% Input
%  start: [1 x 2]
%  num: number that denotes stroke order
function plot_start_loc(start,num,sz_start)  % plot_start_loc函数接受三个输入参数：笔画的起始点start、笔画的编号num和起始点的大小sz_start。该函数的主要功能是在起始点处绘制一个圆圈，并在圆圈中心显示笔画的编号。
    plot(start(2),start(1),'o','MarkerEdgeColor','k','MarkerFaceColor','w',...
        'MarkerSize',sz_start);
    text(start(2),start(1),num2str(num),...
        'BackgroundColor','none','EdgeColor','none',...
        'FontSize',sz_start,'FontWeight','normal','HorizontalAlignment','center');
end

% Color map for the stroke of index k   % get_color函数的功能是为输入的笔画编号k返回一个颜色值。该函数内部定义了一个颜色名称的单元格数组scol，其中包含了一组预定义的颜色名称。该函数根据输入的笔画编号k，返回scol中对应的颜色名称。
%具体来说，如果输入的笔画编号k小于等于预定义颜色的个数，即k <= ncol，则返回scol中第k个颜色名称。否则，返回scol中的最后一个颜色名称。
function out = get_color(k)
    scol = {'r',[0,0.8,0],'b','m',[0,0.8,0.8]};
    ncol = length(scol);
    if k <=ncol
       out = scol{k}; 
    else
       out = scol{end}; 
    end
end