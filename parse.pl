#!/usr/bin/perl -w

use Fcntl;
use utf8;
use constant PACKET_SIZE=>4096;
use constant PACKET_INTERVAL=>0;
use constant FALSE=>0;
use constant TRUE=>1;

my ($b_Read, $f_target);

my $content_length; my $f_begin_FL=FALSE; my $f_num=0;

$f_target='out';
my $f_length=$f_target.'_flength';
my $f_raw=$f_target.'_fraw';
$b_Read=0; my $h_Read=0;
my $h_mime=FALSE;

sub reopen {if ($f_begin_FL) {fclose();fopen();} else {fopen();}}

sub fopen {
	$f_num++;
	unlink($f_target.'_'.$f_num) if (-e $f_target.'_'.$f_num);
	sysopen(TMP, $f_target.'_'.$f_num, O_WRONLY | O_CREAT) or die("cannot open data : $!");
	binmode TMP, ':raw';
	my $ofh=select(TMP); $|=1; select($ofh);
	$f_begin_FL=TRUE;
	$h_mime=TRUE;
	}

sub fclose {
	close(TMP) or die("cannot close data : $!");
	$f_begin_FL=FALSE;
	}

binmode STDIN, ':raw';

while($__LINE=<STDIN>) {
	if ($__LINE=~m/^\r\n$/ && $h_mime) {$h_Read+=length $__LINE; next;}
	if ($__LINE=~m/^[\-]{5,}[0-9]+[\-]{2}(\r\n)?$/i) {$h_Read+=length $__LINE; next;}
	if ($__LINE=~m/^[\-]{5,}[0-9]+(\r\n)?$/i) {$h_Read+=length $__LINE; reopen(); next;}
	if ($__LINE=~m/^Content-Disposition:/i) {$h_Read+=length $__LINE; next;}
	if ($__LINE=~m/^Content-Type:/i) {$h_Read+=length $__LINE; next;}
	print TMP $__LINE;
	$h_mime=FALSE;
	select(undef, undef, undef, PACKET_INTERVAL);
}

close(TMP) or die("cannot close data : $!");

