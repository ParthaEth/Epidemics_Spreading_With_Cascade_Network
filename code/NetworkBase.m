classdef NetworkBase
    % I though we will inherit this for a outer class but it looks like we
    % do not need to right now. So the name might not be very appropriate
    properties(SetAccess = public)
        list_nodes = cell(0);
        connectionMat;
    end
    methods
        %TODO(Dinesh): See if we could have a work around for the fact that
        %now we hav to pass around the this object back and forth.
        function this = connectAstoBs(this, As, Bs)
            %directed connection from A to B
            len_As = length(As);
            len_Bs = length(Bs);
            num_elem = length(this.list_nodes);
            if(As > num_elem || Bs > num_elem)
                error('Trying to connect invalid nodes. Add first');
            end
            for i=1:len_As
                for j=1:len_Bs
                    this.connectionMat(As(i),Bs(j)) = 1;
                end
            end
        end
        function this = addNode(this, node)
            num_elem = length(this.list_nodes);
            this.list_nodes{num_elem+1} = node;
            this.connectionMat(num_elem+1,1:num_elem) = zeros(1,num_elem);
            this.connectionMat(1:num_elem+1,num_elem+1) = zeros(num_elem+1,1);
        end
        % TODO(Dinesh): Delete functionality may be needed
    end
end