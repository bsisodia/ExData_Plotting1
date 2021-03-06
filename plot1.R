# Ensure that environment is not having objects from previous runs or other scripts
rm(list-ls())

# Define As functions to convert date and numeric data appropriately 
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
setAs("character","myNumeric", function(from) as.numeric(as.character(from)))

# Read the CSV and do coercing of data. Get only those columns which are needed
entireData<-read.csv("data/household_power_consumption.txt",header=TRUE,sep=";",
                     colClasses=c('myDate','character', rep('myNumeric',7)))[,c("Date","Global_active_power")]

# Subset the data for given date range and remove NA
subsetData<-entireData[entireData$Date >= "2007-02-01" & entireData$Date <= "2007-02-02",]
subsetData = subsetData[complete.cases(subsetData),]


# Draw histogram and define labels
hist(subsetData$Global_active_power, col = "Red"
     , main = "Global Active Power"
     , xlab = "Global Active Power (kilowatts)")

#Copy to PNG
dev.copy(png, width = 480, height = 480, file = "plot1.png")

#Reset device
dev.off()