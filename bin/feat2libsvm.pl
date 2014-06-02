#!/usr/bin/perl -w

use Getopt::Long;

my @opt_output_columns;

GetOptions ("c=s" => \@opt_output_columns,
	   );

my $arg_positive = shift @ARGV;	# Coding
my $arg_negative = shift @ARGV;	# Noncoding

my $arg_unknown = shift @ARGV;	# Unknown, just as a placehold

# XXX: allow comma-separated lists, see Getopt::Long document
@opt_output_columns = split(/,/,join(',',@opt_output_columns));

unless (scalar (@opt_output_columns) >= 1) {
  die "At least one feature should be specified";
}

&convert($arg_positive, "1") unless (!$arg_positive || ($arg_positive eq "NA"));
&convert($arg_negative, "-1") unless (!$arg_negative || ($arg_negative eq "NA"));
&convert($arg_unknown, "999") unless (!$arg_unknown || ($arg_unknown eq "NA"));

# (from libSVM README)
# <label> <index1>:<value1> <index2>:<value2> ...
# .
# .
# .

# <label> is the target value of the training data. For classification,
# it should be an integer which identifies a class (multi-class
# classification is supported). For regression, it's any real
# number. For one-class SVM, it's not used so can be any number. <index>
# is an integer starting from 1, <value> is a real number. The indices
# must be in an ascending order. The labels in the testing data file are
# only used to calculate accuracy or error. If they are unknown, just
# fill this column with a number. (-- here, we use the "999" as a placehold)

sub convert {
  my ($filename, $classlabel) = @_;

  open FH, "<$filename" or die "Can't open Pos feat file($filename): $!";

  while (my $l = <FH>) {
    chomp $l;
    next if $l =~ /^\s*$/;
    next if $l =~ /^\s*#/;

    next if $l =~ /^QueryID/;	# SC: the banner

    my @fields = split /\t/, $l;

    my @output_svm_line;
    push @output_svm_line, $classlabel;	# 1: coding -1: noncoding
  
    my $i = 1;
    foreach my $col (@opt_output_columns) {
      my $real_index = $col - 1; # XXX: perl array started from 0, not 1

      if (defined($fields[$real_index])) {
	push @output_svm_line, join(":", $i, $fields[$real_index]);
	$i++;
      }
    }
    print join(" ", @output_svm_line), "\n";
  }

  close FH;
}
