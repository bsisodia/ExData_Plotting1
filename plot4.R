# Ensure that environment is not having objects from previous runs or other scripts
rm(list-ls())

# Define As functions to convert date and numeric data appropriately 
setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y") )
setAs("character","myNumeric", function(from) as.numeric(as.character(from)))

# Read the CSV and do coercing of data. Get only those columns which are needed
entireData<-read.csv("data/household_power_consumption.txt",header=TRUE,sep=";",
                     colClasses=c('myDate','character', rep('myNumeric',7)))[,c("Date","Time","Global_active_power","Global_reactive_power","Voltage"
                                                                                ,"Sub_metering_1","Sub_metering_2","Sub_metering_3")]

# Subset the data for given date range and remove NA
subsetData<-entireData[entireData$Date >= "2007-02-01" & entireData$Date <= "2007-02-02",]
subsetData = subsetData[complete.cases(subsetData),]

#Add new column for a combined date and time
subsetData$DateTime= as.POSIXct(paste(subsetData$Date, subsetData$Time), format="%Y-%m-%d %H:%M:%S")

#Set graphical parameters mar= c(4.2,4.2,2,2)+0.1,
par(mfrow = c(2,2),  cex = 0.5)


# Draw all the  graphs in 4 designated areas
with(subsetData,{
  plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")
  plot(DateTime, Voltage, type = "l", ylab = "Voltage", xlab = "datetime")
  plot(DateTime,Sub_metering_1, type="l", col = "black", ylab = "Energy Sub Metering", xlab = "")
  points(DateTime,Sub_metering_2, type="l", col = "red")
  points(DateTime,Sub_metering_3, type="l", col = "blue")
  legend("topright", lty = 1,  col = c("black","red","blue")
         , legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
         , bty = "n")
  plot(DateTime, Global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "datetime")
}) 


#Copy to PNG
dev.copy(png, width = 480, height = 480, file = "plot4.png")

#Reset device
dev.off()