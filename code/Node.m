classdef Node
    properties
        %these properties are only necessary if you intend to plot the
        %network for visualization. The default values are zero.
        x_
        y_
    end
    properties (GetAccess = 'public', SetAccess = 'private')
        health_; % an array of doubles containing current and past healths
        Settings_ = struct; % Holder for node specific settings parameters.
    end
    methods
        function this = Node(varargin)
            % The constructor of the node class. At least one parameter is 
            % necessary. First parameter indicates the maximum number of 
            % past health vlues this node will remember. Other parameters 
            % are alpha, beta, resistanceThreshold and recoveryRate. Please
            % refer to "http://arxiv.org/pdf/physics/0611244v2.pdf" in 
            % order to know their effects. 
            if (nargin == 0)
                error('Max number of past states to remember is needed')
            end
            this.health_ = zeros(varargin{1} + 1, 1); %At least two state 
            % Creating enough places with neutral health values. If the max
            % connection delay limit is set to 1 we need to keep two health
            % values. 1 for current time and one from past time step.
            if (nargin == 1)
                this.Settings_ = struct('alpha', 0.1,...
                    'beta', 0.025, ...
                    'resistanceThreshold', 0.5,...
                    'recoveryRate', 4);
                return;
            end
            this.x_ = rand(1,1);
            this.y_ = rand(1,1);
            settingParams = {'alpha', 'beta', ...
                'resistanceThreshold', 'recoveryRate'};
            if nargin > 5
                error('Too many parameters');
            end
            for i=2:nargin
                this.Settings_.(settingParams{i-1}) = varargin{i};
            end
        end
        
        function this = setPos(this, x, y)
            % This method sets two position parameters corresponding to a
            % node. They are entirely for plotting purpose and do not
            % influence the simulation in any way.
            % Random values have been assigned to these parameters in the
            % constructor.
            this.x_ = x;
            this.y_ = y;
        end
        
        function this = setCurrentHealth(this, health)
            %Convenience method to set health of a node in run-time. Can be
            %used to infect nodes in the beginning of simulation.
            this.health_(1) = health;
        end
        
        function this = runNode(this, dt, effectFromNeighbours)
            %Updates current nodes health by running the simulation by one 
            %time step. This method should always be called from 
            %'simulateNetwork' method in 'NetworkBase'.
            dx = (-this.health_(1)/this.Settings_.recoveryRate +...
                Sigmoid(this, effectFromNeighbours))*dt;
            h1 = this.health_(1) + dx;
            this.health_(end) = [];
            this.health_ = [h1; this.health_];
        end
        
        function theta_y = Sigmoid(this, y)
            % Helper method to runNode. Calculates sigmoid functionality.
            theta_y = (1-exp(-this.Settings_.alpha*y))/...
                (1+exp(-this.Settings_.alpha*...
                (y-this.Settings_.resistanceThreshold)));
        end
    end
end
