#!/usr/bin/perl -w

use strict;
use warnings;

my $arg_seq = shift @ARGV;

my @query_ids;
my @seq_len;

my ($curr_query_id, $curr_query_seq_len);

open FH, "<$arg_seq" or die "Can't open file ($arg_seq): $!";
while (my $l = <FH>) {
  chomp $l;
  next if $l =~ /^\s*$/;
  next if $l =~ /^\s*#/;

  if ($l =~ /^>(\S+)/) {
    if ($curr_query_id) {
      push @query_ids, $curr_query_id;
      push @seq_len, $curr_query_seq_len;
    }
    $curr_query_id = $1;
    $curr_query_seq_len = 0;
  }
  else {
    $curr_query_seq_len += ($l =~ tr/a-zA-Z//);
  }
}

# Oops...don't forget the last entry...:)
push @query_ids, $curr_query_id;
push @seq_len, $curr_query_seq_len;

close FH;

while (my $l = <STDIN>) {
  chomp $l;
  my ($cl1, $prob_coding1, undef, $cl2, $prob_coding2, undef) = (split /\s+/, $l);

  next unless ($cl1 && $cl1 =~ /^-?\d+/);

  my $query_id = shift @query_ids || "NA";
  my $query_seq_len = shift @seq_len || "NA";
  
  my $class = "noncoding";

  # FIXME: check the validation of the following algorithm
  my $final_prob_coding = $prob_coding1;
  if ($cl2 && $prob_coding2) {
    $final_prob_coding = ($final_prob_coding + $prob_coding2) / 2;
  }
  
  if ($final_prob_coding >= .5) {
    $class = "coding";
  }

  print join("\t", $query_id, $query_seq_len, $class, $final_prob_coding), "\n";
}
