#!/usr/bin/perl -w

use strict;
use warnings;

print join("\t", "QueryID", "CDSLength", "Score", "Used", "Strict"), "\n";

# >gi|344283|emb|A01270.1| T.ovis mRNA for 45W antigen (partial) \\
# [framefinder (0,702) score=55.32 used=75.65% {forward,local} ]

while (my $l = <STDIN>) {
  chomp $l;

  if ($l =~ /^>(\S+)/) {
    my $id = $1;
    if (my ($start, $end, $score, $used, $type)
	= ($l =~ /framefinder \((\d+),(\d+)\) score=(\S+) used=(\S+)% \{forward,(\w+)\} /)) {
      my $length = $end - $start + 1;
      print join("\t", $id,
		 $length, $score, $used,
		 $type eq "strict"?1:0), "\n";
    }
  }
}

