library(plyr)
library(ggplot2)

# reading data file in the working dir and loading into memory if they do not exist on the memory
if(!exists("NEI")){NEI <- readRDS("summarySCC_PM25.rds")}
if(!exists("SCC")){SCC <- readRDS("Source_Classification_Code.rds")}

# Aggregate the total emission by year: 1999, 2002, 2005, 2008
TotalEmissionbyYear <- aggregate(Emissions ~ year, NEI, sum)
# Change scale of emission from ton to killo-ton  
TotalEmissionbyYear$EmissionsKTon <- round(TotalEmissionbyYear[,2]/1000,2)

# Set plotting output to PNG file and plot a vertical bar graph
png('plot1.png', width=480, height=480)
barplot(TotalEmissionbyYear$EmissionsKTon, 
        names.arg=TotalEmissionbyYear$year, 
        main=expression('The Annual Total PM'[2.5]*' emissions'), 
        xlab="Year", 
        ylab=expression(paste('PM'[2.5]*' emission in K-Ton')))
dev.off()