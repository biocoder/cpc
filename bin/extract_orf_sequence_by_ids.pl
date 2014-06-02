#!/usr/bin/perl -w

use strict;
use warnings;

use Bio::SeqIO;

######################################################################
# 
# FIXME: Well, I know, the code is low-performance, fat, dirty and
# ... suck, but what would you expect a man with damned flu-fever to
# write in less than 10 minutes, anyway?
# 
# Yes, yes, yes ... I know what the code SHOULD be, too: it could be
# an index-driven system like the BLAST report and also fine-tuned
# with bulk of comments.... I promise, yes, I promise to great R.M.S
# that I'll fill the gap as soon as possible.... :)
# 

my %ids;

$ids{uc($_)}++ foreach (@ARGV);

exit 0 unless keys(%ids);		# SC

my $in  = Bio::SeqIO->new(-fh => \*STDIN, 
			  -format => 'fasta');
my $out  = Bio::SeqIO->new(-fh => \*STDOUT, 
			  -format => 'fasta');

while ( my $seq = $in->next_seq() ) {
  my $id = $seq->display_id;
  if (exists $ids{uc($id)}) {
    $out->write_seq($seq);
  }
}
