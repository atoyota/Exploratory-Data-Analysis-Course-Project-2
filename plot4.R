library(plyr)
library(ggplot2)

# reading data file in the working dir and loading into memory if they have not been read
if(!exists("NEI")){NEI <- readRDS("summarySCC_PM25.rds")}
if(!exists("SCC")){SCC <- readRDS("Source_Classification_Code.rds")}

# Merge (i.e. Join) NEI and SCC where NEI.SCC== SCC.SCC into NEISCCMerged if it has not been done before
if(!exists("NEISCCMerged")){
  NEISCCMerged <- merge(NEI, SCC, by="SCC") 
}

# take out NEISCCMerged records having "coal" in Short.Name
coalSourceNEISCC <- NEISCCMerged[grepl("coal", NEISCCMerged$Short.Name, ignore.case=TRUE), ]

#Aggregate total coral sourced emission
coalEmissionTotalByYear <- aggregate(Emissions ~ year, coalSourceNEISCC, sum)

# Set plotting output to PNG file and plot a a polygonal line graph coal source emission by year
png('plot4.png')
g <- ggplot(coalEmissionTotalByYear, aes(factor(year), Emissions))
g <- g + geom_line(aes(group=1)) + 
        geom_point(stat="identity") +
        xlab("Year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        geom_text(aes(label=round(Emissions, digit=0), size=2, vjust=1.5)) +
        ggtitle('Total Coal Sourced Emissions in from 1999 to 2008') 
print(g)  
dev.off()