#!/usr/bin/perl -w

use strict;
use warnings;

use Data::Dumper;

my $curr_query_id;
my $curr_sbjct_id;

my ($curr_hit_seq_count, $curr_hit_HSP_count);
my @curr_hit_score;
my @curr_hit_frame_scores;	# [0|1|2] ==> \(100, 200, ...,300)

# Banner
print join("\t", "QueryID", "hit_seq_count", "hit_HSP_count", "hit_score", "frame_score", "frame_score2"), "\n";

while (my $l = <STDIN>) {
  chomp $l;
  next if ($l =~ /^\s*$/);
  next if ($l =~ /^\s*#/);

  my ($query_id, $sbjct_id, $q_start, $e, $score) = (split /\t/, $l)[0,1,6,10,11];

  unless ($curr_query_id) {
    # First run, initialize necessary state
    $curr_query_id = $query_id;
    $curr_sbjct_id = $sbjct_id;

    $curr_hit_seq_count = 1;
    $curr_hit_HSP_count = 0;

    @curr_hit_score = ();
    @curr_hit_frame_scores = ();
  }

  unless ($curr_query_id eq $query_id) {
    # New Query meet, dump existed information and reset it
    &show_result();
    
    $curr_query_id = $query_id;
    $curr_sbjct_id = $sbjct_id;

    $curr_hit_seq_count = 1;
    $curr_hit_HSP_count = 0;
    @curr_hit_score = ();
    @curr_hit_frame_scores = ();
  }

  $curr_hit_HSP_count++;
  unless ($curr_sbjct_id eq $sbjct_id) {
    $curr_hit_seq_count++;
    $curr_sbjct_id = $sbjct_id;
  }

  my $hit_score;
  if ($e > 0) {
    $hit_score = -1 * log($e)/log(10);
  }
  else {
    $hit_score = 250;		# min float = 1e-250
  }

  push @curr_hit_score, $hit_score;

  my $curr_frame = ($q_start % 3);
  my $ra = $curr_hit_frame_scores[$curr_frame];
  push @{$ra}, $hit_score;
  $curr_hit_frame_scores[$curr_frame] = $ra;

}

if ($curr_query_id) {
  &show_result();
}

# XXX: this function depends on global vars!
sub show_result() {
  my $curr_hit_score = &mean(@curr_hit_score);
  
  my $curr_frame_score = &variance(&get_elements_count($curr_hit_frame_scores[0]),
				   &get_elements_count($curr_hit_frame_scores[1]),
				   &get_elements_count($curr_hit_frame_scores[2]),
				  );
  
  my $curr_frame_score2 = &variance(&mean(@{$curr_hit_frame_scores[0]}),
				    &mean(@{$curr_hit_frame_scores[1]}),
				    &mean(@{$curr_hit_frame_scores[2]}),
				   );

  
  print join("\t", $curr_query_id,
	     $curr_hit_seq_count, $curr_hit_HSP_count,
	     $curr_hit_score,
	     $curr_frame_score, $curr_frame_score2,
	    ), "\n";

}


sub get_elements_count() {
  my $ra = shift;
  return 0 unless ($ra && ref($ra) eq "ARRAY");
  return scalar(@{$ra});
}

sub mean() {
  my @nums = @_;

  return 0 unless scalar(@nums);
  
  my $sum = 0;
  $sum += $_ foreach (@nums);

  my $mean = $sum / scalar(@nums);
  return $mean;
}

sub variance() {
  my @nums = @_;
  
  my $mean = &mean(@nums);
  
  my $variance = 0;
  foreach (@nums) {
    my $deviation = $_ - $mean;
    $variance += $deviation ** 2;
  }

  $variance /= (scalar(@nums) - 1);

  return ($variance);
}
