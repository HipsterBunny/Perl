Perl-parse
====

I wrote a Perl script that would go through and populate
a database table with a userName, userData, and a year by
reading a text file.

The specific format of said text file was:

'delimiter' 'userName'<br>
'userdata' <br>
'userdata' <br>
'userdata' <br>
'userdata' <br>

ex: 

*ercurtis<br>
she lived<br>
she ate.<br>
that was pretty much it<br><br>
*darland<br>
no one really likes him<br>
because he eats <br>
everyone's food<br>

ect...

It would then take this information and break it up
into userName and userData.  Each line of user data
was then put into a single string called '$data' with a
~ inbetween the different lines so I could break them up
into nicer looking statements when I took them out of the
database.
