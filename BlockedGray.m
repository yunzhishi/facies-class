h = colormap(gray);

h2 = h;

for hhh = 1:21

h2(hhh,:) = h(round(64/8),:);

end

for hhh = 22:42

h2(hhh,:) = h(round(64/2),:);

end
for hhh = 43:64

h2(hhh,:) = h(round(64*7/8),:);

end

blockedgray = h2;

close all