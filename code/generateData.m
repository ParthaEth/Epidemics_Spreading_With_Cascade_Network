str = randi([0, 10], 6, 6)/10;
str=str.*triu(ones(6,6),1);
str=str+str'
delay = randi([0, 10], 6, 6)/10;
delay=delay.*triu(ones(6,6),1);
delay=delay+delay'

fileID1 = fopen('edge_strength1.txt', 'w')
fprintf(fileID1, '%6d %6d %6d %6d %6d %6d\n', str)
fileID2 = fopen('edge_timedelay1.txt', 'w')
fprintf(fileID2, '%6d %6d %6d %6d %6d %6d\n', delay)
fclose(fileID1)
fclose(fileID2)