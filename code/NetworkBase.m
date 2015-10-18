%A simple graph and its plot
classdef NetworkBase
   properties(SetAccess = public)
      list_nodes = cell(0);
   end
   methods
       function this = addNode(this, node)
         this.list_nodes{end+1} = node;
      end
   end
end