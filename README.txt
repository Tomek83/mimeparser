Author: tomek.antczak@gmail.com
Perl based parser for decode raw post data provided by browser during upload process of one or multiple files to server. This is just simple example of mechanism which can be used for building web based uploader. Dump files contains binary data of one or several files (images, short movies) placed in mime content headers running this ...

cat dump_raw_1.bin | ./parse.pl

in linux shell, grabs all those files and saves them in current working directory
