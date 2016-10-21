library(plyr)
library(ggplot2)

# reading data file in the working dir and loading into memory if they have not been read
if(!exists("NEI")){NEI <- readRDS("summarySCC_PM25.rds")}
if(!exists("SCC")){SCC <- readRDS("Source_Classification_Code.rds")}

# take out NEI record from Baltimore City and Type = ON-ROAD meaning the emission from Motor Vehicle
OnRoadNEI <- NEI[NEI$fips=="24510" & NEI$type=="ON-ROAD",  ]

#Aggregate total emission of On-Road type in Baltimore
totalOnRoadEmissionBaltimoreByYear <- aggregate(Emissions ~ year, OnRoadNEI, sum)

# Set plotting output to PNG file and plot a a polygonal line graph of Motor Vehicle Emissions in Baltimore City
png('plot5.png')
g <- ggplot(totalOnRoadEmissionBaltimoreByYear, aes(factor(year), Emissions))
g <- g + geom_line(aes(group=1)) + 
        geom_point(stat="identity") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        geom_text(aes(label=round(Emissions, digit=0), size=2, vjust=1.5)) +
        ggtitle('Total Emissions from Motor Vehicle in Baltimore City, Maryland 1999-2008') 
print(g)  
dev.off()