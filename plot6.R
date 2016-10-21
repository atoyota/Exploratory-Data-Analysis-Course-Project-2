library(plyr)
library(ggplot2)
require(gridExtra)
# reading data file in the working dir and loading into memory if they have not been read
if(!exists("NEI")){NEI <- readRDS("summarySCC_PM25.rds")}
if(!exists("SCC")){SCC <- readRDS("Source_Classification_Code.rds")}

# take out NEI record where Type = ON-ROAD from Baltimore City and LA
BaltimoreLAOnRoadNEI <- NEI[(NEI$fips=="24510" | NEI$fips=="06037") & NEI$type=="ON-ROAD", ]

#Aggregate total emission of On-Road type and add a colum of county names in the table
totalOnRoadEmissionByYear <- aggregate(Emissions ~ fips+year, BaltimoreLAOnRoadNEI, sum)
totalOnRoadEmissionByYear$County <- ifelse (totalOnRoadEmissionByYear$fips =="24510", "Baltimore City", "Los Angeles")
                                         
# Set plotting output to PNG file, set its screen size
png("plot6.png", width=1040, height=700)

# plot two polygonal line graph for total Motor Vehicle emission by year taken from Baltimore and LA
gpol <- ggplot(totalOnRoadEmissionByYear, aes(year, Emissions, color=County))
gpol <- gpol + geom_line() + 
        geom_point(stat="identity") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        geom_text(aes(label=round(Emissions, digit=0), size=2, vjust=1.5)) +
        ggtitle('Comparison of Emissions from Motor Vehicle in Baltimore City, Maryland and Los Angeles, CA 1999-2008') 

# plot two box plot graph for total Motor Vehicle emission taken from Baltimore and LA
gbox <- ggplot(data=totalOnRoadEmissionByYear, aes(x=year, y=Emissions, group=County)) + 
     facet_grid(. ~ County) + 
     guides(fill=F) + 
     geom_boxplot(aes(fill=year)) + 
     stat_boxplot(geom ='errorbar') + 
     ylab(expression(paste('PM'[2.5], ' Emissions'))) + 
     xlab('Year') +  
     ggtitle('Change in Emission in Baltimore City, Maryland and Los Angeles') + 
     geom_jitter(alpha=0.10) 
#print the graphs
grid.arrange(gpol, gbox, ncol = 2)
dev.off()