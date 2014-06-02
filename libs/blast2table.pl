#!/usr/bin/perl -w

# The code is downloaded from
# http://safari5.bvdep.com/0596002998/blast-APP-E, as the appendix E
# of book "BLAST" by Joseph Bedell, Ian Korf, Mark Yandell, published
# by O'Reilly.

# Pub Date: July 2003 
# ISBN: 0-596-00299-8 
# Pages: 360

use strict;
use Getopt::Std;
use vars qw($opt_p $opt_b $opt_e $opt_m $opt_n);
getopts('p:b:e:m:n:');
my $PERCENT = $opt_p ? $opt_p : 0;
my $BITS    = $opt_b ? $opt_b : 0;
my $EXPECT  = $opt_e ? $opt_e : 1e30;
my $START   = $opt_m ? $opt_m : 0;
my $END     = $opt_n ? $opt_n : 1e30;

my ($Query, $Sbjct);
my $HSP = "";
while (<>) {
    if    (/^Query=\s+(\S+)/) {outputHSP(); $Query = $1}
    elsif (/^>(\S+)/)         {outputHSP(); $Sbjct = $1}
    elsif (/^ Score = /) {
        outputHSP();
        my @stat = ($_);
        while (<>) {
            last unless /\S/;
            push @stat, $_
        }
        my $stats = join("", @stat);
        my ($bits) = $stats =~ /(\d\S+) bits/;
        my ($expect) = $stats =~ /Expect\S* = ([\d\.\+\-e]+)/;
		$expect = "1$expect" if $expect =~ /^e/;
        my ($match, $total, $percent)
            = $stats =~ /Identities = (\d+)\/(\d+) \((\d+)%\)/;
        my $mismatch = $total - $match;
        
        $HSP = {bits => $bits, expect => $expect, mismatch => $mismatch,
            percent => $percent, q_begin => 0, q_end => 0, q_align => 0,
            s_begin => 0, s_end => 0, s_align => ""};
    }
    elsif (/^Query:\s+(\d+)\s+(\S+)\s+(\d+)/) {
        $HSP->{q_begin}  = $1 unless $HSP->{q_begin};
        $HSP->{q_end}    = $3;
        $HSP->{q_align} .= $2;
    }
    elsif (/^Sbjct:\s+(\d+)\s+(\S+)\s+(\d+)/) {
        $HSP->{s_begin}  = $1 unless $HSP->{s_begin};
        $HSP->{s_end}    = $3;
        $HSP->{s_align} .= $2;
    }
}
outputHSP();

sub outputHSP {
    return unless $HSP;
    return if $HSP->{percent}  < $PERCENT;
    return if $HSP->{bits}     < $BITS;
    return if $HSP->{expect}   > $EXPECT;
    return if ($HSP->{q_begin} < $START or $HSP->{q_end} < $START);
    return if ($HSP->{q_begin} > $END   or $HSP->{q_end} > $END);
    foreach my $field ('percent', 'q_align', 'mismatch', 's_align',
    				'q_begin', 'q_end', 's_begin', 's_end', 'expect', 'bits'){
    	print "$field not defined\n" if not defined $HSP->{$field};
    }
    print join("\t", $Query, $Sbjct, $HSP->{percent},
        length($HSP->{q_align}) - 1, # GaoG: well, I don't know why,
                                     # but it seems the BLAST -m8 just
                                     # give out one less length here..
	       $HSP->{mismatch},
        countGaps($HSP->{q_align}) + countGaps($HSP->{s_align}),
        $HSP->{q_begin}, $HSP->{q_end}, $HSP->{s_begin}, $HSP->{s_end},
        $HSP->{expect}, $HSP->{bits}), "\n";
    $HSP = "";
}

sub countGaps {
    my ($string) = @_;
    my $count = 0;
    while ($string =~ /\-+/g) {$count++}
    return $count;
}
