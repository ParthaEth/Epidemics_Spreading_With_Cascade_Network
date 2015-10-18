classdef Node
    properties 
        x_
        y_
    end
    methods
        function this = setPos(this, x, y)
            this.x_ = x;
            this.y_ = y;
        end
    end
end