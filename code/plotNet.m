function plotNet(net)
% Ideally should be called just once in the beginning and always the states
% of the entities that are creted should be updated with update now
% function. So this is not very efficient!
num_nodes = length(net.list_nodes);
figure
for i=1:num_nodes
    plot(net.list_nodes{i}.x_,net.list_nodes{i}.y_,'b*')
    if i==1
        hold on;
    end
end
end