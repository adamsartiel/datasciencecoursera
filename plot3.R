plot3<-function(){
  library(dplyr)
  windows()
  power<-read.table("household_power_consumption.txt",header=TRUE, sep=";")
  v<-power[,"Global_active_power"]
  i<-v=="?"
  cleanpower<-power[!i,]
  df1<-data.frame(cleanpower$Date, cleanpower$Time, Sub1=as.numeric(as.character(cleanpower$Sub_metering_1)),Sub2=as.numeric(as.character(cleanpower$Sub_metering_2)),Sub3=cleanpower$Sub_metering_3)
  filtpower<-filter(df1, (cleanpower.Date=="1/2/2007"|cleanpower.Date=="2/2/2007"))
  filtpower$D<-paste(filtpower$cleanpower.Date, filtpower$cleanpower.Time, sep=" ")
  filtpower$TOD<-strptime(filtpower$D, format="%d/%m/%Y %H:%M:%S")
  with(filtpower,plot(x=as.POSIXct(TOD), y=Sub1, type="l", col="black", main="", xlab="", ylab="Energy sub metering"))
  with(filtpower,points(x=as.POSIXct(TOD), y=Sub2, type="l", col="red"))
  with(filtpower,points(x=as.POSIXct(TOD), y=Sub3, type="l", col ="blue"))
  with(filtpower,legend("topright",c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),col=c("black","red","blue"), lty="solid"))
  dev.print(device=png, filename="plot3.png", width=480)
  }
