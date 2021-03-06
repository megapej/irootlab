%> @brief Report base class.
%>
%> Reports are blocks that output a @ref log_report class.
%>
%> They descend from @ref vis, but they do generate output.
%>
%> The code generator @gencode.m will automatically open a web browser to show the report if it is GUI-obtained.
classdef irreport < vis
    properties
        %> =1 whther to generate the images
        flag_images = 1;
        
        %> =1. Whether to create the tables
        flag_tables = 1;
    end;
    methods
        function o = irreport()
            o.classtitle = 'HTML Report';
            o.flag_out = 1;
            o.flag_trainable = 0;
            o.flag_fixednf = 0;
            o.flag_graphics = 0;
            o.flag_out = 1;
        end;
    end;
    

    % *-*-*-*-*-*-*-* TOOLS
    methods(Static)
        %> Creates an "img" HTML tag that links both to the PNG and FIG versions
        %> @param fn file name with/without extension
        %> @param perc =100 percentage width (0-100). If zero, will use original size
        %> @param flag_fig = 1 Whether to generate an "a" tag to the FIG version as well
        function s = get_imgtag(fn, perc, flag_fig)
            if nargin < 2 || isempty(perc)
                perc = 100;
            end;
            if nargin < 3 || isempty(flag_fig)
                flag_fig = 1;
            end;
            
            
            [s_path, fn, s_ext] = fileparts(fn); %#ok<NASGU,ASGLU>

            s = ['<center>', 10, ...
                 '<a href="', fn, '.png" target="_blank"><img border=0 src="', fn, '.png" ', ...
                 iif(perc > 0, ['width="', int2str(perc), '%"'], ''), '></a><br />', 10];
            if flag_fig
                s = cat(2, s, ['<a href="', fn, '.fig">Download FIG</a>&nbsp;&nbsp;', 10, ...
                               '<a href="matlab:open(''', fn, '.fig'')">Open FIG in MATLAB</a><br />', 10]);
            end;
            s = cat(2, s, ['</center>', 10]);
        end;
             
        %> Used to save a figure both as png and fig, and close it
        %> @return an "img" HTML tag that may be used if wanted
        %> @param fn =(autogenerated) file name with/without extension
        %> @param perc =100 percentage width (0-100)
        %> @param res =(screen resolution) Resolution in DPI, e.g., 150, 300
        function s = save_n_close(fn, perc, res)
            if nargin < 1 || isempty(fn)
                fn = find_filename('irr_image', [], 'png', 0);
            end;
            if nargin < 2 || isempty(perc)
                perc = 100;
            end;
            if nargin < 3
                res = [];
            end;
            
            [s_path, fn, s_ext] = fileparts(fn); %#ok<NASGU,ASGLU>
            
            save_as_png([], fn, res);
            save_as_fig([], fn);
            close;
            pause(0.25); % Attempt to wait until MATLAB gets internally sorted
            
            s = irreport.get_imgtag(fn, perc);
        end;
    end;        
end
