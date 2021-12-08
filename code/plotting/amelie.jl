
x=rand(1:6, 1000, 9)
y=sum(x, dims = 2)
mean(y)/9
std(y)/3


mean(x)
std(x)