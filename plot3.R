library(plyr)
library(ggplot2)

# reading data file in the working dir and loading into memory if they have not been read
if(!exists("NEI")){NEI <- readRDS("summarySCC_PM25.rds")}
if(!exists("SCC")){SCC <- readRDS("Source_Classification_Code.rds")}

#Extract observation records taken from Baltimore City (fips="24510")
NEIBaltimore <- NEI[which(NEI$fips == "24510"), ]

# Aggregate the total emission by type as well as by year: 1999, 2002, 2005, 2008
TotalBaltimorEmissionbyTypebyYear <- aggregate(Emissions ~ year+type, NEIBaltimore, sum)

# Set plotting output to PNG file and plot a polygonal line graph for each emission source type
png('plot3.png')
g <- ggplot(TotalBaltimorEmissionbyTypebyYear, aes(year, Emissions, color = type))
g <- g + geom_line() +
         xlab("Year") +
         ylab(expression('Total PM'[2.5]*" Emissions")) +
         ggtitle('Total Emissions by Type in Baltimore City, Maryland from 1999 to 2008') 
print(g) 
dev.off()