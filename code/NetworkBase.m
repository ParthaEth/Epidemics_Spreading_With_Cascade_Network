classdef NetworkBase
    % This class definition is based on the model discussed in
    % http://arxiv.org/pdf/physics/0611244v2.pdf
    % Hence the variable names that do not have meaning associated with 
    % them can directly be looked up in the paper
    properties(SetAccess = public)
        list_nodes = cell(0);
        connectionMat;
        connectionDelayMat;
        a;
        b;
    end
    % The above variables should be scope limited for reusability
    % improvement.
    methods
        function this = NetworkBase(varargin)
            %default constructor of the class. It can take either no input
            %argument or 2 arguments. If no arguments are provided default
            %values for the parameter and b are assumed. Please refer to
            %the paper for further explanation. This class cannot be
            %constructed with any other type of parameters.
            switch nargin
                case 0
                    this.a = 4;
                    this.b = 3;
                case 2
                    this.a = varargin{1};
                    this.b = varargin{2};
                otherwise
                    error('Wrong number of arguments');
            end
        end
        function this = connectAstoBs(this, As, Bs, StrengthMat, DelayMat)
            %Directed connection from A to B. If undirected connections are
            %intended first connect As to Bs and then connect Bs to As. As
            %and Bs can be vectors. In that case every element in As are
            %connected to every element in Bs. If StrengthMat and DelayMat
            %are not provided, then default values are assumed. Please note
            %that they are arbitrary values e.g. 0.5 for strength and 0 for
            %time delay.
            len_As = length(As);
            len_Bs = length(Bs);
            num_elem = length(this.list_nodes);
            if(As > num_elem || Bs > num_elem)
                error('Trying to connect invalid nodes. Add first');
            end
            switch nargin
                case 3
                    for i=1:len_As
                        for j=1:len_Bs
                            this.connectionMat(As(i),Bs(j)) = .5;
                            this.connectionDelayMat(As(i),Bs(j)) = 0;
                        end
                    end
                case 5
                    for i=1:len_As
                        for j=1:len_Bs
                            this.connectionMat(As(i),Bs(j)) = ...
                                StrengthMat(i, j);
                            this.connectionDelayMat(As(i),Bs(j)) = ...
                                DelayMat(i, j);
                        end
                    end
                otherwise
                    error('Wrong number of arguments');
            end
        end
        
        % TODO(Future user) : Add undirected connection functionality for
        % faster execution. Less data needs to be passed and less function
        % call overhead.
        function this = addNode(this, node)
            %This method adds a node to the existing network. It assumes no
            %connection to or from this node to any other node. Connection
            %strength matrix is augmented with a row and a column with
            %zeros in it. Delay matrix is also initialized with zero.
            %Be sure to connect a node to other nodes after adding 
            %them otherwise they will not have effect on the network and 
            %yet consume computational power  
            num_elem = length(this.list_nodes);
            this.list_nodes{num_elem+1} = node;
            this.connectionMat(num_elem+1,1:num_elem) = ...
                zeros(1,num_elem);
            this.connectionMat(1:num_elem+1,num_elem+1) = ...
                zeros(num_elem+1,1);
            % same for connectionDelayMat
            this.connectionDelayMat(num_elem+1,1:num_elem) = ...
                zeros(1,num_elem);
            this.connectionDelayMat(1:num_elem+1,num_elem+1) = ...
                zeros(num_elem+1,1);
        end
 
        function this = delete(this, node_index)
            %This function removea a node from the network. Any connection
            %to any other node is also removed. This is just a convenience 
            %function and is never called in the main simulation runtime.
            %It can be used to remove chosen nodes during runtime. Please
            %note that the node index following the removed node changes
            %after this function is called.
            this.list_nodes(node_index) = [];
            this.connectionMat(node_index,:) =[];
            this.connectionMat(:,node_index)=[];
            this.connectionDelayMat(:,node_index) = [];
            this.connectionDelayMat(node_index,:) = [];
        end
        
        function this = simulateNetwork(this, dt)
        % This method simulates the network. It should be called after
        % desired number of nodes have been added and successfully
        % connected. This method takes only one parameter, the time step
        % for which the simulation is to be carried out. Please note that
        % the integration performed in this function is Euler integration
        % and usually the model dynamics are highly nonlinear so dt should
        % be chosen rather small in order to avoid high linearization
        % error. Also it should be noted that for a longer period of
        % simulation this function should be called in a loop with 
        % simulation for small time step in each loop.
            for indexCurrentNode = 1:length(this.list_nodes)
                % This method performs the simulation with the
                % assumption that the connection in the graph are directed.
                % An overload specifically for undirected networks can
                % improve execution speed. Please reffer to
                % http://arxiv.org/pdf/physics/0611244v2.pdf
                % for details.
                effectFromNeighbours = 0;
                for indexConnectedNode = 1:length(this.list_nodes)
                    healthIndex = round(1 + this.connectionDelayMat...
                        (indexCurrentNode, indexConnectedNode)/dt);
                    effectFromNeighbours = effectFromNeighbours +...
                        this.connectionMat(indexCurrentNode, ...
                            indexConnectedNode)...
                        *this.list_nodes{indexConnectedNode...
                            }.health_(healthIndex)...
                        *exp(-this.list_nodes{indexCurrentNode...
                            }.Settings_.beta...
                        *this.connectionDelayMat(indexCurrentNode,...
                            indexConnectedNode))...
                        /this.connectivityWeight(indexConnectedNode);
                end
                %Send the disturbance from neighbors to the node currently
                %being dealt with and execute its run method for one 
                %timestep.
                this.list_nodes{indexCurrentNode} = ...
                    this.list_nodes{indexCurrentNode}.runNode(dt,...
                        effectFromNeighbours);
            %Finally loop over all the nodes.
            end
        end
        
        function weight = connectivityWeight(this, indexConnectedNode)
            % Helper function that calculates f(o_j) in Eq.2 in 
            % http://arxiv.org/pdf/physics/0611244v2.pdf
            O_j = find(this.connectionMat(indexConnectedNode,:) > 0);
            weight = this.a*O_j/(1 + this.b * O_j);
        end
    end
end