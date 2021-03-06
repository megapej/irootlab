%> This SODATAITEM is generated by a FHG
classdef soitem_fhg < soitem_sostagechoice
    properties
        %> A @ref log_fselrepeater object
        log;
        stab;
        %> String describing the FHG setup
        s_setup;
    end;
    
    methods
        function o = soitem_fhg()
            o.moreactions = [o.moreactions, 'extract_log_fselrepeater'];
        end;
        
        function out = extract_log_fselrepeater(o)
            out = o.log;
        end;
    end;
end
