plot1<-function(){
  library(dplyr)
  windows()
  power<-read.table("household_power_consumption.txt",header=TRUE, sep=";")
  v<-power[,"Global_active_power"]
  i<-v=="?"
  cleanpower<-power[!i,]
  df1<-data.frame(cleanpower$Date, cleanpower$Time, Global_active_power=as.numeric(as.character(cleanpower$Global_active_power)))
  filtpower<-filter(df1, (cleanpower.Date=="1/2/2007"|cleanpower.Date=="2/2/2007"))
  with (filtpower, hist(Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power"))
  dev.print(device=png, filename="plot1.png", width=480)
  }