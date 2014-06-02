#!/usr/bin/perl -w

use strict;
use warnings;

my @output_lines;

while (my $f = shift @ARGV) {
  open FH, "<$f" or die "Can't open file($f): $!";

  my $curr_line_index = 0;

  while (my $l = <FH>) {
    chomp $l;
    next if $l =~ /^\s*$/;
    next if $l =~ /^\s*#/;

    next if $l =~ /^labels/;	# skip possible "labels 1 -1"

    my @fields = split /\s+/, $l;
    my $ra = $output_lines[$curr_line_index];
    $ra = [] unless $ra;
    push @{$ra}, @fields;
    $output_lines[$curr_line_index] = $ra;

    $curr_line_index++;
  }
  close FH;
}

foreach my $ra (@output_lines) {
  print join("\t", @{$ra}), "\n";
}
