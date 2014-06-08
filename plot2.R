# plot 2

# check if we have the subset we need already saved,
# so we don't need to load a large dataset everytime
if (!file.exists('fData.dump')) {
    # download and unzip the file if it is not present
    if (!file.exists('household_power_consumption.txt')) {
        if (!file.exists('exdata-data-household_power_consumption.zip')) {
            download.file(url='http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip',
                          destfile='exdata-data-household_power_consumption.zip')
        } 
        unzip('exdata-data-household_power_consumption.zip')
    } 
    
    # read the file
    fData <- read.table('household_power_consumption.txt', 
                        header=TRUE, sep=";", na.strings="?",
                        colClasses=c("character", "character", rep("numeric",7)))
    
    # convert columns "Date" and "Time" to a single one of type "date"
    fData$Date <- strptime(paste(fData$Date,fData$Time),"%d/%m/%Y %H:%M:%S")
    fData$Time <- NULL
    
    # subset the dataframe
    fData <- subset(fData, Date >= strptime('2007-2-1',format='%Y-%m-%d') 
                    & Date < strptime('2007-2-3',format='%Y-%m-%d') )
    
    # save subset to disk
    dput(fData,'fData.dump')
    
} else {
    # if we have the subset already saved, just load it
    fData <- dget('fData.dump')
}

# I'm Brazilian, so my locale is not en_US by default. That was making
# the axis values to be localized in portuguese instead of english
Sys.setlocale(category="LC_ALL",locale="English_United States.1252")

# now we are ready to create the plot!
png(filename='plot2.png',width=480,height=480)
plot(fData$Date, fData$Global_active_power, type='n',
     xlab='',
     ylab='Global Active Power (kilowatts)')
lines(fData$Date, fData$Global_active_power)

# save plot to disk
dev.off()