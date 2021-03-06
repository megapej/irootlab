%> @brief Learning curve: (percent dataset used for training)x(classification rate)
%>
%> The purpose of this class is to store a cell of vectors (the @ref celldata property). The vectors may vary in size.
%>
%> Each row has a different "name" (@ref rownames property).
%>
%> If generated by a @ref reptt_sgs, there will be one case only (first log) and the changing conditions are the different blocks.
%>
%> @sa as_dsperc_x_rate, reptt_sgs
classdef log_celldata < irlog
    properties
        %> X-axis. Related to the columns of celldata
        fea_x;
        %> X-axis label. Related to the columns of celldata
        xname = '?';
        %> X-axis unit. Related to the columns of celldata
        xunit = '';
        %> X-axis label. Related to the rows of celldata
        yname = '?';
        %> X-axis unit. Related to the rows of celldata
        yunit = '';

        %> Cell of dimensions (number of cases)x(number of conditions per case)
        %> @arg Option 1: Cell of estlogs to extract the rate from
        %> @arg Option 2: Cell of vectors (of various sizes) whose averages will be taken
        celldata;
        %> Case names, for legend
        rownames;
    end;
    
    methods
        function o = log_celldata()
            o.classtitle = 'Cell data';
            o.moreactions = [o.moreactions, {'extract_dataset'}];
            o.flag_ui = 0;
        end;

        
        
        %> Draws with hachures (optional)
        %>
        %> @param idx=all Indexes of cases
        %> @param flag_std=1 Whether to draw the standard deviation as well
        %> @param flag_perc_x=[] Whether to make the x-axis a percentage. If not passed, will use internal setup
        %> @param flag_perc_y=[] Whether to make the y-axis a percentage. If not passed, will use internal setup
       function draw(o, idx, flag_std)
            if ~exist('idx', 'var') || isempty(idx)
                idx = 1:size(o.celldata, 1);
            end
            
            if ~exist('flag_std', 'var') || isempty(flag_std)
                flag_std = 1;
            end;

            nidx = numel(idx);
            hh = [];
            for i = 1:nidx
                if size(o.celldata, 1) < idx(i)
                    irerror(sprintf('celldata property has less than %d cases(s)!', idx(i)));
                end;

                allvalues = o.celldata(idx(i), :);
                curve = cellfun(@(x) mean(x), allvalues);

                if flag_std
                    stds = cellfun(@(x) std(x), allvalues);                   
                    draw_stdhachure(o.fea_x, curve, stds, find_color(i));
                    hold on;
                end;
                
                hh(i) = plot(o.fea_x, curve, 'Color', find_color(i), 'LineWidth', scaled(3));
                legends{i} = o.rownames{idx(i)};

                hold on;
                
%                 % Polynomial fit
%                 p = polyfit(MX*o.fea_x, MY*curve, 9);
%                 pv = polyval(p, MX*o.fea_x);
%                 plot(MX*o.fea_x, pv, 'k--', 'LineWidth', scaled(2));
            end;
            
            if ~isempty(hh)
                legend(hh, legends);
            end;
            title(o.get_description());
            format_xaxis(o);
            format_yaxis(o);
            format_frank();
            make_box();
        end;

        
        
        
        %> Extracts a dataset
        %>
        %> Dataset X will have same dimension of @ref celldata. Values will be the averages of each vector within @ref celldata
        function data = extract_dataset(o)
            [nrows, ncols] = size(o.celldata); %#ok<NASGU>
            data = irdata();
            data.X = cellfun(@(x) mean(x), o.celldata);
            data.classes = (0:nrows-1)';
            data.classes = zeros(nrows, 1);
            data.classlabels = o.rownames;
            data.fea_x = o.fea_x;
            data.xname = o.xname;
            data.xunit = o.xunit;
            data.yname = o.yname;
            data.yunit = o.yunit;
            data.title = ['Dataset generated by ', o.get_description()];
            data = data.assert_fix();
        end;
    end;
end
