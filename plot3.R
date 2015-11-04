# This script uses cp and grep which
#     are unix/BSD/Linux/OSx utilities.
#     On Windows computers comparable
#     capabilities exist via the
#     installation of Cygwin.
# The working directory must hold the data file
#
# Check to determine if the data table and the datetime vector
#     have been previously generated.  If they have, use them
#     and jump to the plot code.  Otherwise generate the
#     the data table and vector.
if( !("dataDT" %in% ls())|!("datetime" %in% ls()) ) {
	# Copy the data file to a working file named 'data.txt'
	system("cp household_power_consumption.txt data.txt")

	# Grep extracts the header of the data file to a file named, 'dataTable.txt'
	system("grep 'Date' data.txt > dataTable.txt")

	# Grep extracts the desired data rows and appends them to the
	#     'dataTable.txt' file.  This is the subset which
	#     constitutes the desired data.
	system("grep '^[1|2]/2/2007' data.txt >> dataTable.txt")

	# Use the data.table library
	library(data.table)

	# Fread the file 'dataTable.txt' into a data.table
	dataDT <- fread("dataTable.txt")

	# Check for data table size and NAs. 
	if( dim(dataDT)[1]!=2880) {print("The table is missing records")}
	if( dim(dataDT)[1]*dim(dataDT)[2]!=table(is.na(dataDT))[[1]] ) {print("There are some table anomalies")}
	

	# The datetime vector is not added back to the data table as such
	#     an operation is unnecessary and costly.  Since this is
	#     an exploratory operation, we want a quick and easy
	#     way to look at the data
	datetime<-strptime(paste(dataDT$Date, dataDT$Time),format="%d/%m/%Y %T")
}

# Turn on the png device
png(file="plot3.png", width=480, height=480, bg="white")
# Make the plot
plot(datetime,dataDT$Sub_metering_1,type="n",ylab="Energy sub metering",xlab="")
lines(datetime,dataDT$Sub_metering_1,col="black")
lines(datetime,dataDT$Sub_metering_2,col="red")
lines(datetime,dataDT$Sub_metering_3,col="blue")
legend("topright",col=c("black","red","blue"),legend=c("Sub_metering_1  ","Sub_metering_2  ","Sub_metering_3  "),lty=c(1,1,1))

# Turn off the png device
dev.off()
