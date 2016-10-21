library(plyr)
library(ggplot2)

# reading data file in the working dir and loading into memory only if they have not been on the memory
if(!exists("NEI")){NEI <- readRDS("summarySCC_PM25.rds")}
if(!exists("SCC")){SCC <- readRDS("Source_Classification_Code.rds")}

#Extract observation records taken from Baltimore City (fips="24510")
NEIBaltimore <- NEI[which(NEI$fips == "24510"), ]

# Aggregate the total emission in by year: 1999, 2002, 2005, 2008
TotalBaltimorEmissionbyYear <- aggregate(Emissions ~ year, NEIBaltimore, sum)

# Set plotting output to PNG file and plot a vertical bar graph
png('plot2.png')
barplot(TotalBaltimorEmissionbyYear$Emissions, 
        names.arg=TotalBaltimorEmissionbyYear$year, 
        main=expression('The Annual Total PM'[2.5]*' emissions in Baltimore City, Maryland'), 
        xlab="Year", 
        ylab=expression(paste('PM'[2.5]*' emission')))
dev.off()