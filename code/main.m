clc
clear all
close all
net = NetworkBase;
node = Node;
node = node.setPos(0,0);
net = net.addNode(node);
node = node.setPos(1,1);
net = net.addNode(node);
plotNet(net)