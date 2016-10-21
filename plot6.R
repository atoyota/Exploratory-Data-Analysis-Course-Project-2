library(plyr)
library(ggplot2)

# reading data file in the working dir and loading into memory if they have not been read
if(!exists("NEI")){NEI <- readRDS("summarySCC_PM25.rds")}
if(!exists("SCC")){SCC <- readRDS("Source_Classification_Code.rds")}

# take out NEI record where Type = ON-ROAD from Baltimore City and LA
BaltimoreLAOnRoadNEI <- NEI[(NEI$fips=="24510" | NEI$fips=="06037") & NEI$type=="ON-ROAD", ]

#Aggregate total emission of On-Road type in Baltimore
totalOnRoadEmissionByYear <- aggregate(Emissions ~ fips+year, BaltimoreLAOnRoadNEI, sum)
totalOnRoadEmissionByYear$County <- ifelse (totalOnRoadEmissionByYear$fips =="24510", "Baltimore City", "Los Angeles")
                                         
# Set plotting output to PNG file and plot two polygonal line graph for Motor Vehicle emission taken from Baltimore and LA
png("plot6.png", width=1040, height=480)
g <- ggplot(totalOnRoadEmissionByYear, aes(year, Emissions, color=County))
g <- g + geom_line() + 
        geom_point(stat="identity") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        geom_text(aes(label=round(Emissions, digit=0), size=2, vjust=1.5)) +
        ggtitle('Comparison of Emissions from Motor Vehicle in Baltimore City, Maryland and Los Angeles, CA 1999-2008') 
print(g)

dev.off()