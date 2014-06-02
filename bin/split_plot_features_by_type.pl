#!/usr/bin/perl -w

my $arg_output_homo = shift @ARGV;
my $arg_output_orf = shift @ARGV;

open FH_HOMO, ">$arg_output_homo" or die "Can't open file ($arg_output_homo) for writting";
open FH_ORF, ">$arg_output_orf" or die "Can't open file ($arg_output_orf) for writting";

while (my $l = <STDIN>) {
  chomp $l;
  my $source = (split /\t/, $l)[1]; # C2: source
  if ($source =~ /^BLAST/) {
    print FH_HOMO $l, "\n";
  }
  elsif ($source =~ /^ORF/) {
    print FH_ORF $l, "\n";
  }
}

close FH_HOMO;
close FH_ORF;
