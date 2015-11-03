clc
clear all
close all
% TODO(Dinesh) : Can you write some unit tests?
%%%%%%%%%Set parameters%%%%%%%%
timeStep = 0.01;
maxConnectionDelay = 2; %in unit of timeSteps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
net = NetworkBase;
node = Node(maxConnectionDelay,1,2,3,4);
node = node.setPos(0,0);
net = net.addNode(node);
node = Node(maxConnectionDelay);
node = node.setPos(1,1);
net = net.addNode(node);
net = net.connectAstoBs(1,2); %directed connection frm A to B
net = net.connectAstoBs(2,1);
net = net.simulateNetwork(timeStep);
plotNet(net)