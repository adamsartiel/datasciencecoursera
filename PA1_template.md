---
title: "First Assignment"
author: "Adam Sartiel"
date: "Nov. 3rd, 2018"
output: html_document
---
========================================================================================  

## Analysis of walking steps per day during 2,500 5-minutes intervals over two months.  
First some preparation steps - load libraries, set working directory, load file.


```r
knitr::opts_chunk$set(echo = TRUE)
library(ggplot2)
library(dplyr)
setwd("C:/Users/Adam/Desktop/R/Reproducible Research/First Assignment")
activity<-read.csv("activity.csv")
```

### First Question: What is mean total number of steps taken per day?
Present an histogram of the steps walked in all intervals during the measurement period:


```r
TotStepsDay<-activity%>%group_by(date)%>%summarise_at(1,funs(sum))

hist(TotStepsDay$steps, col="red", main="Distribution of Steps per Day", xlab="Total Steps")
```

![plot of chunk Steps_per_day_histogram](figure/Steps_per_day_histogram-1.png)
  
  The total steps per day were calculated and charted over the histogram above.



```r
mean<-format(mean(TotStepsDay$steps, na.rm =TRUE), scientific=FALSE)

quant<-format(quantile(TotStepsDay$steps, probs=0.5, na.rm = TRUE), scientific = FALSE)
mean
```

```
## [1] "10766.19"
```

```r
quant
```

```
##     50% 
## "10765"
```
  The mean of steps taken per day is 10766.19 and the median is 10765.  
    
### Second Question: What is the average daily activity pattern?  
Make a time series plot (i.e. \color{red}{\verb|type = "l"|}type="l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)


```r
AveStepsInt<-activity%>%group_by(interval)%>%summarise_at(1,funs(mean), na.rm=TRUE)
qplot(interval, steps, data = AveStepsInt, geom="line", color=I("blue"))
```

![plot of chunk Plotting daily pattern](figure/Plotting daily pattern-1.png)
  
  Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?    
  The plot shows a maximum in the area of interval 800. Let's calculate the exact interval:

```r
MaxStepsInt<-AveStepsInt[,2]==max(AveStepsInt[,2]) #Look of all the steps in intervals, which equals the maximum
MaxStepIntRow<-AveStepsInt[MaxStepsInt==TRUE,]     #Extract the row of the maximum steps interval
mint<-format(as.numeric(MaxStepIntRow[1,1]), scientific=FALSE)
msteps<-format(as.numeric(MaxStepIntRow[1,2]), scientific=FALSE)
mint
```

```
## [1] "835"
```

```r
msteps
```

```
## [1] "206.1698"
```
  The maximum number of average steps is 206.1698 and it is reached on interval 835. 
    
### Third Question: Imputing missing values
Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with \color{red}{\verb|NA|}NAs)


```r
NAS<-is.na(activity$steps)
snas<-as.numeric(sum(NAS))
snas
```

```
## [1] 2304
```
  The total number of missing values is therefore 2304.  
  Let's replace these missing values by the average steps walked in the same interval over the two months.  
  This require 2 for loops: One going through the entire database to find the NAs, the second then called to look in the average steps data frame for an identical interval, and insert it instead of the NA. Once found, the second loop breaks and the program looks for the next NA.

```r
  clean_activity<-activity                #create a mirror file to the activity data
  for (i in 1:nrow(activity)){            #go through data and look for NAs
    if (is.na(activity[i,1])==TRUE){      #if found, go through Average Steps frame and look for match  
      for (j in 1:nrow(AveStepsInt)){
        if (AveStepsInt[j,1]==activity[i,3]){  #if match found, replace NA with the average in the new mirror file
          clean_activity[i,1]=AveStepsInt[j,2] #break afterwards to the next NA.
          break()
        }
      }
    }   
  }
```

  Now let's compare the histograms of both cases:


```r
  TotStepsDayClean<-clean_activity%>%group_by(date)%>%summarise_at(1,funs(sum))
  par(mfrow=c(1,2))
  hist(TotStepsDay$steps, col="red", main="Distribution of Steps per Day", xlab="Total Steps")
  hist(TotStepsDayClean$steps, col="blue", main="With no missing values", xlab="Total Steps")
```

![plot of chunk plot comparison between original and clean data](figure/plot comparison between original and clean data-1.png)
    
  We see a small difference between the histograms. Now let's compare the mean and median values:  
  

```r
  nmean<-format(as.numeric(mean(TotStepsDayClean$steps, na.rm =TRUE)), scientific=FALSE)
  nquant<-format(as.numeric(quantile(TotStepsDayClean$steps, probs=0.5, na.rm = TRUE)), scientific=FALSE)
  nmean
```

```
## [1] "10766.19"
```

```r
  nquant
```

```
## [1] "10766.19"
```
  
  The mean is now 10766.19 compared with 10766.19 prior to cleaning.  
  The median is now 10766.19 compared with 10765 prior to cleaning.  
  As we replaced missing values with average values, there is no change in the mean. The quantile is slightly changed.      
  
### Fourth question: Are there differences in activity patterns between weekdays and weekends?  
  Create a new factor variable in the dataset with two levels ??? ???weekday??? and ???weekend??? indicating whether a given date is a weekday or weekend day.  
  We would add columns 'weekend' to the clean_activity data frame. It would be 'weekend' for Saturdays and Sundays (required to be compared to actual dates, 6th and 7th of October, 2012, due to locales issues).  
  Then, we will re-group the clean_activity data by the intervals and weekend value, and calculate the means per interval for each case.  
  

```r
clean_activity<-mutate(clean_activity, weekend=if_else((weekdays(as.POSIXlt(date, format="%Y-%m-%d"))==weekdays(as.POSIXlt("2012-10-06", format="%Y-%m-%d"))|weekdays(as.POSIXlt(date, format="%Y-%m-%d"))==weekdays(as.POSIXlt("2012-10-07", format="%Y-%m-%d"))), "Weekend", "Weekday"))
```
  We ignore the warnings as they don't affect results.  
  

```r
AveStepsIntClean<-clean_activity%>%group_by(interval,weekend)%>%summarise_at(1,funs(mean), na.rm=TRUE)
```
Make a panel plot containing a time series plot (i.e. \color{red}{\verb|type = "l"|}type="l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis).  
  Finally, we will plot weekdays vs. weekends steps average per intervals:
  

```r
qplot(interval, steps, data = AveStepsIntClean, geom="line", color=weekend, facets=weekend~.)
```

![plot of chunk plot weekdays vs weekends](figure/plot weekdays vs weekends-1.png)

  Indeed the high morning peak in interval 835 disappears on weekends, as people oversleep...  
  
