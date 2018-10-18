plot2<-function(){
  library(dplyr)
  windows()
  power<-read.table("household_power_consumption.txt",header=TRUE, sep=";")
  v<-power[,"Global_active_power"]
  i<-v=="?"
  cleanpower<-power[!i,]
  df1<-data.frame(cleanpower$Date, cleanpower$Time, as.numeric(as.character(cleanpower$Global_active_power)))
  filtpower<-filter(df1, (cleanpower.Date=="1/2/2007"|cleanpower.Date=="2/2/2007"))
  filtpower$D<-paste(filtpower$cleanpower.Date, filtpower$cleanpower.Time, sep=" ")
  filtpower$TOD<-strptime(filtpower$D, format="%d/%m/%Y %H:%M:%S")
  with(filtpower, plot(as.numeric.as.character.cleanpower.Global_active_power..~as.POSIXct(TOD), main="Global Active Power (kilowatts)",type="l", xlab="", ylab="Global Active Power (kilowatts)"))
  dev.print(device=png, filename="plot2.png", width=480)
  }