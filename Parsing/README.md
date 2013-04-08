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
