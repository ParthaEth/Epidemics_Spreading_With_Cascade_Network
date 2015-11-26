classdef Node
    properties
        x_
        y_
    end
    properties (GetAccess = 'public', SetAccess = 'private')
        health_;
        Settings_ = struct;
    end
    methods
        function this = Node(varargin)%health, alpha, beta, 
            % resistanceThreshold
            if (nargin == 0)
                error('Max number of past states to remember has to be set')
            end
            this.health_ = zeros(varargin{1} + 1, 1); %atleast two state 
            % Creating enough places with neutral health values. If the max
            % connection dely limit is set to 1 we need to keep two health
            % values. 1 for current time and one from past time step.
            if (nargin == 1)
                this.Settings_ = struct('alpha', 0.1,...
                    'beta', 0.025, ...
                    'resistanceThreshold', 0.5,...
                    'recoveryRate', 4);
                return;
            end
            this.x_ = rand(1,1); % generates floats? - generates doubles
            this.y_ = rand(1,1);
            settingParams = {'alpha', 'beta', ...
                'resistanceThreshold', 'recoveryRate'}; % where is setting
            %Params defined?
            if nargin > 5
                error('Too many parameters');
            end
            for i=2:nargin
                this.Settings_.(settingParams{i-1}) = varargin{i};
            end
        end
        
        function this = setPos(this, x, y)
            this.x_ = x;
            this.y_ = y;
        end
        
        function this = setCurrentHealth(this, health)
            this.health_(1) = health;
        end
        
        function this = runNode(this, dt, effectFromNeighbours)
            dx = (-this.health_(1)/this.Settings_.recoveryRate +...
                Sigmoid(this, effectFromNeighbours))*dt;
            % Mistakes: I see mistakes here. Partha's version is commented
            % in your version, for final value, health_(1)=health_(2)
            %this.health_(1) = this.health_(1) + dx;
            %this.health_(end) = [];
            %this.health_ = [this.health_(1); this.health_];
            
            h1 = this.health_(1) + dx;
            this.health_(end) = [];
            this.health_ = [h1; this.health_];
            
        end
        
        function theta_y = Sigmoid(this, y)
            theta_y = (1-exp(-this.Settings_.alpha*y))/...
                (1+exp(-this.Settings_.alpha*...
                (y-this.Settings_.resistanceThreshold)));
        end
    end
end

