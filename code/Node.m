classdef Node
    properties 
        x_
        y_
        health_;
        Settings_ = struct;
    end
    methods
        function this = Node(varargin)%health, alpha, beta, ResistanceThreshold
            if (nargin == 0)
                this.health_ = 0;
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
            if nargin > 4
                error('Too many parameters');
            end
            this.health_ = varargin{1};
            for i=2:nargin
                this.Settings_.(settingParams{i}) = varargin{i};
            end
        end
        function this = setPos(this, x, y)
            this.x_ = x;
            this.y_ = y;
        end
        function this = runNode(this, dt, effectFromNeighbours) 
            dx = -this.health_/this.Settings.recoveryRate +...
                 Sigmoid(this, effectFromNeighbours)*dt;
            this.health_ = this.health_ + dx;
        end
        function theta_y = Sigmoid(this, y)
            theta_y = (1-exp(-this.Settings_.alpha*y))/...
                      (1+exp(-this.Settings_.alpha*...
                      (y-this.Settings.ResistanceThreshold)));
        end
    end
end

