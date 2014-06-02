
#!/usr/bin/perl -w

use strict;
use warnings;

############################################################
# 
# FIXME: THE CODE IS RATHER DIRTY (AND SUCK)....
# 
############################################################

my $arg_blastx_table = shift @ARGV;
my $arg_ff_result = shift @ARGV;

my %blastx_table;

open FH, "<$arg_blastx_table" or die "Can't open BLAST TABLE file ($arg_blastx_table): $!";

while (my $l = <FH>) {

  chomp $l;
  my ($query_id, $sbjct_id, $q_start, $q_end, $s_start, $s_end, $e_value) = (split /\t/, $l)[0,1,6,7,8,9,10];

  my $ra_HSPs = $blastx_table{$query_id};
  my $ra_HSP_prop = [$sbjct_id, $e_value, $q_start, $q_end, $s_start, $s_end];
  push @{$ra_HSPs}, $ra_HSP_prop;

  $blastx_table{$query_id} = $ra_HSPs;
  
}
close FH;

my %ff_feats;

open FH, "<$arg_ff_result" or die "Can't open file ($arg_ff_result): $!";

while (my $l = <FH>) {
  chomp $l;

  # >gi|344283|emb|A01270.1| T.ovis mRNA for 45W antigen (partial) \\
  # [framefinder (0,702) score=55.32 used=75.65% {forward,local} ]
  if ($l =~ /^>(\S+)/) {
    my $id = $1;
    if (my ($start, $end, $score, $used, $type)
        = ($l =~ /framefinder \((\d+),(\d+)\) score=(\S+) used=(\S+)% \{forward,(\w+)\} /)) {
      $ff_feats{$id} = { start => $start + 1, end => $end + 1,
			 score => $score, used => $used,
			 type => $type eq "strict"?"Full":"Partial",
		       };
    }
  }
}
close FH;


############################################################
# 
# Read in the BLASTX feat
# 
# XXX: according to the protocol, each input sequence should have ONE
# AND ONLY ONE entry in the BLASTX feat file.

while (my $l = <STDIN>) {
  chomp $l;
  next if $l =~ /^\s*$/;

  next if $l =~ /^QueryID/;	# Skip header

  # 0       1             2              3         4           5
  # QueryID hit_seq_count hit_HSP_count  hit_score frame_score frame_score2
  my ($query_id, $hit_seq_count, $hit_score, $frame_score2) = (split /\t/, $l)[0,1,3,5];


  # Output1: ORF
  if (exists $ff_feats{$query_id}) {
    my $rh = $ff_feats{$query_id};

    print join("\t", $query_id, "ORF_FRAMEFINDER",
	       $rh->{start}, $rh->{end},
	       $rh->{used}, $rh->{score},
	       $rh->{type}), "\n";
  }

  # Output2: BLASTX feat
  print join("\t", $query_id, "BLAST",
	     $hit_seq_count,
	     $hit_score,
	     $frame_score2), "\n";

  # Output3: all matched BLASTX HSPs
  if (exists $blastx_table{$query_id}) {
    my $ra_HSPs = $blastx_table{$query_id};
    foreach my $ra_HSP_prop (@{$ra_HSPs}) {
      # [$sbjct_id, $e_value, $q_start, $q_end, $s_start, $s_end];
      print join("\t", $query_id, "BLASTHSP", @{$ra_HSP_prop}), "\n";
    }
  }
}


