# This script uses cp and grep which
#     are unix/BSD/Linux/OSx utilities.  On Windows
#     computers comparable capabilities exist
#     when Cygwin is installed.
# The working directory must hold the data file
# Copy the data file to a working file named 'data.txt'
system("cp household_power_consumption.txt data.txt")

# Grep extracts the header of (column names row) the data file to a file named, 'dataTable.txt'
system("grep 'Date' data.txt > dataTable.txt")

# Grep extracts the desired rows and appends the rows to the file 'dataTable.txt'.
# This then is the desired subset of the original data file.   
system("grep '^[1|2]/2/2007' data.txt >> dataTable.txt")

library(data.table)

# Fread the file 'dataTable.txt' into a data.table
dataDT <- fread("dataTable.txt")

# Turn on the png device
png(file="plot1.png",width=480,height=480,bg="white")
# Create the histogram on the default graphics device
#     Set the histogram color, the x axis label, and the title
hist(dataDT$Global_active_power,col="red",xlab="Global Active Power (kilowatts)",main="Global Active Power")

# Turn off the png device
dev.off()
