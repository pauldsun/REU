data = readtable("DAQ- Crosshead, … - (Timed).csv");
size(data)
figure()
plot(data.Crosshead, data.Load*1000,'b','LineWidth',1.5)
hold on
plot(data.Crosshead(250),data.Load(250)*1000,'mo')
plot(data.Crosshead(500),data.Load(500)*1000,'go')
max(data.Load);
y_fit = data.Load(250:500)*1000;
x_fit = data.Crosshead(250:500);
fit = polyfit(x_fit, y_fit, 1);
stiffness = fit(1)


x_range = linspace(min(data.Crosshead),max(data.Crosshead),2000);
y = polyval(fit, x_range);
plot(x_range,y,'--r','LineWidth',1.5)
xlabel("Displacement (mm)", Interpreter='latex')
ylabel("Force (N)", Interpreter='latex')
legend('Original Data', '','','Stiffness Fit', Location='northwest')

avgStealthStiffness(5) = stiffness
mean(avgStealthStiffness)
std(avgStealthStiffness)