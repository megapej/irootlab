%> @brief Bagging ensemble.
%>
%> Each time the classifier is trained, several component classifiers will be generated. The number of components and how their
%> respective training data are obtained are specified by the @c sgs property.
%>
%> Allows multi-training.
%>
%> @sa uip_aggr_bag.m, demo_reptt_bag.m, test_bagging.m
classdef aggr_bag < aggr
    properties
        %> must contain a block object that will be replicated as needed
        block_mold = [];
        %> SGS to do the bagging. Doesn't need to be a sgs_randsub one, actually. K-fold will work, too.
        sgs;
    end;

    methods
        function o = aggr_bag(o)
            o.classtitle = 'Bagging';
        end;
    end;
    
    methods(Access=protected)
        function o = do_boot(o)
        end;

        % Adds classifiers when new classes are presented
        function o = do_train(o, data)
            obsidxs = o.sgs.get_obsidxs(data);
            no_reps = size(obsidxs, 1);
            
%             ipro = progress2_open('BAGGING', [], 0, no_reps);
            for i_rep = 1:no_reps
                datasets = data.split_map(obsidxs(i_rep, 1));

                cl = o.block_mold.boot();
                cl = cl.train(datasets(1));
                o = o.add_clssr(cl);
%                 ipro = progress2_change(ipro, [], [], i_rep);
            end;
%             progress2_close(ipro);

        end;
    end;
end