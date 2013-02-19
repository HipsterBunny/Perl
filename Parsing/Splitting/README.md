Perl-simpleParse
====

This is a stripped down version of the original Perl script, basically you give it in data and it will
(very crudely) take out all of the ':D' *super smiley emoticons from what ever text file you give it.

I will admit, it's not really handy unless you really hate super smiley faces in your text files... 
and also it isn't smart enough to be able to see a difference between :D and :Dog, meaning if your
file did indeed contain ":Dog" you would get a print out of " og".

the $parseAt function should be changed to be $ARGV[1] in this program as well.  It will be more useful
for everyone that way.  


Perl PARSING... AWAY!
