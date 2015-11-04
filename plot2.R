# This script uses cp and grep which
#     are unix/BSD/Linux/OSx utilities.
#     On Windows computers comparable
#     capabilities exist via the
#     installation of Cygwin.
# The working directory must hold the data file
#
# Check to determine if the data table
#     has been previously generated.  If it has, use it
#     and jump to the datetime code.  Otherwise generate the
#     the data table.
if( !("dataDT" %in% ls()) ) {
	
	# Copy the data file to a working file named 'data.txt'
	system("cp household_power_consumption.txt data.txt")

	# Grep extracts the header (column names row) of the data file to a file named, 'dataTable.txt'
	system("grep 'Date' data.txt > dataTable.txt")

	# Grep extracts the desired data rows and appends them to the
	#     'dataTable.txt' file.  This is the subset which
	#     constitutes the desired data.
	system("grep '^[1|2]/2/2007' data.txt >> dataTable.txt")

	# Use the data.table library for speed and concise efficiency
	library(data.table)

	# Fread the file 'dataTable.txt' into a data.table
	dataDT <- fread("dataTable.txt")

	# Check for data table size and NAs. 
	if( dim(dataDT)[1]!=2880) {print("The table is missing rows")}
	if( dim(dataDT)[1]*dim(dataDT)[2]!=table(is.na(dataDT))[[1]] ) {print("There are some table anomalies")}
}

# The datetime vector is not added back to the data table as such
#     an operation is unnecessary and costly.  Since this is
#     an exploratory operation, we want a quick and easy
#     way to look at the data.
datetime<-strptime(paste(dataDT$Date,dataDT$Time),format="%d/%m/%Y %T")

png(file="plot2.png", width=480, height=480, bg="white")
# Make the plot
plot(datetime,dataDT$Global_active_power,type="n",ylab="Global Active Power (kilowatts)",xlab="")
lines(datetime,dataDT$Global_active_power)

# Turn off the png device
dev.off()

