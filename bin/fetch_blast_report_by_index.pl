#!/usr/bin/perl -w

use strict;
use warnings;

my $arg_input_blast_report = shift @ARGV;
my $arg_input_index = shift @ARGV;

my %index;

open FH_INDEX, "<$arg_input_index" or die "Can't open index ($arg_input_index): $!";
while (my $l = <FH_INDEX>) {
  chomp $l;
  my ($query_id, $start, $end) = split /\t/, $l;
  $index{$query_id}->{start} = $start;
  $index{$query_id}->{end} = $end;
}

close FH_INDEX;

open FH_BLAST, "<$arg_input_blast_report" or die "Can't open blast ($arg_input_blast_report): $!";

while (my $l = <STDIN>) {
  my @ids = split /\s+/, $l;
  foreach my $id (@ids) {
    next unless exists $index{$id};

    my $start = $index{$id}->{start};
    my $end = $index{$id}->{end};
    
    my $buf;
    seek(FH_BLAST, $start, 0);
    read(FH_BLAST, $buf, $end - $start + 1);
    print $buf, "\n";
  }
}
close FH_BLAST;

