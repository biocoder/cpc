#!/usr/bin/perl -w

use strict;
use warnings;

my $arg_feat_file = shift @ARGV;

my %existed_feat;		# QueryID ==> whole line

open FEAT, "<$arg_feat_file" or die "Can't open file ($arg_feat_file): $!";
while (my $l = <FEAT>) {
  chomp $l;
  next if $l =~ /^\s*$/;
  next if $l =~ /^\s*#/;

  my $query_id = (split /\t/, $l)[0];
  unless ($query_id && !($query_id eq "QueryID")) {
    next;			# SC: skip heading line
  }

  $existed_feat{$query_id} = $l;
}

close FEAT;

# Banner
print join("\t", "QueryID", "hit_seq_count", "hit_HSP_count", "hit_score", "frame_score", "frame_score2"), "\n";

while (my $seq = <STDIN>) {
  chomp $seq;

  next unless ($seq =~ /^>(\S+)/);
  my $seq_id = $1;
  
  if (exists $existed_feat{$seq_id}) {
    print $existed_feat{$seq_id}, "\n";
  }
  else {
    # Not found, default values
    print join("\t", $seq_id, 0, 0, 0, 0, 0), "\n";
  }
}

