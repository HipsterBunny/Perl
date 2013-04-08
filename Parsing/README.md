"I don't want to look through all these folders," you say - and you're right.  Who has time to figure out what's in each and every one of these virtual containment units? Not me, that's for sure. So let me help you out.

Database:

    The 'Database' folder holds a perl script that takes in a line of data and chunks it up into 
    specific pieces of data.  After the inData has been broken into pieces, with a proper database 
    connection these pieces of data are placed into a pre-determined table.  Currently 
    the '$data' field is encoded so that if you have someone just arbitrarily looking 
    through your DB, they don't know exactly what they are looking at.  However if they are 
    really nosey, it's not too hard to figure out how to decode it.

Splitting:

    This is a simplified version of the 'Database' script.  Basically there is a '$parseAt' variable
    that holds a phrase that we don't want in our text file.  In this case I chose ':D' emoticon.  
    You give it some inData (which I have provided), the program will generate an outData.txt 
    for you.  I have it adding ~'s in the spots where the '$parseAt' value was located because I was using them 
    for formatting in the original. isn't that sweet?!  . :D.

File Splitter:

    The file splitter will (the way it's currently written) take in a file containing records, and then split
    those records into a header file (which holds information about how many other files there are, a
    main file, institution file, interests file, and tests file.  It reads the data from a file called 'infile'
    of which a basic test file can be created with the perl script in the 'Making Test Data' folder.  
    
    The length of each record, and the number of records is recorded on line 25-32 of the fileParser.pl script.
    The test data script can be ammended to reflect any changes here.
    
    I had a really nice test data file maker, and apparently I misplaced it - but if I find it I will put it up.
    The current one is really pretty ugly... and I don't admire anything about it just FYI.  It's just a quick
    thrown together version so you can see how the file splitter works. Nuff Said.
