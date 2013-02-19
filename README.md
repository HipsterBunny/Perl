Perl-parse
====

I wrote a Perl script that would go through and populate
a database table with a userName, userData, and a year by
reading a text file.

The specific format of said text file was:

<delimiter><userName>
<userdata>
<userdata>
<userdata>
<userdata>

ex: 

*ercurtis
she lived
she ate.
that was pretty much it
*darland
no one really likes him
because he eats 
everyone's food

ect...

It would then take this information and break it up
into userName and userData.  Each line of user data
was then put into a single string called '$data' with a
~ inbetween the different lines so I could break them up
into nicer looking statements when I took them out of the
database.
