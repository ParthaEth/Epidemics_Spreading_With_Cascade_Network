classdef Node
    properties
        x_
        y_
        health_;
        Settings_ = struct;
    end
    methods
        function this = Node(varargin)%health, alpha, beta, resistanceThreshold
            if (nargin == 0)
                error('Max number of past states to remember has to be set')
            end
            this.health_ = zeros(varargin{1} + 1, 1);
            if (nargin == 1)
                this.Settings_ = struct('alpha', 0.1,...
                    'beta', 0.025, ...
                    'resistanceThreshold', 0.5,...
                    'recoveryRate', 0.1);
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
            this.x_ = x;
            this.y_ = y;
        end
        
        function this = runNode(this, dt, effectFromNeighbours)
            dx = -this.health_(1)/this.Settings_.recoveryRate +...
                Sigmoid(this, effectFromNeighbours)*dt;
            this.health_(2:end) = this.health_(1:end-1);
            this.health_(1) = this.health_(1) + dx;
        end
        
        function theta_y = Sigmoid(this, y)
            theta_y = (1-exp(-this.Settings_.alpha*y))/...
                (1+exp(-this.Settings_.alpha*...
                (y-this.Settings_.resistanceThreshold)));
        end
    end
end

