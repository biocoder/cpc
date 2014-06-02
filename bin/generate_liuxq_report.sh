#!/bin/bash

arg_input_evd_plot_feat_base=$1
arg_input_working_dir=$2

arg_input_query_id=$3

arg_output_file=$4

MYOWN_LOC=`dirname $0`;		# XXX: some hacking:)
c_fetch_blast_report="$MYOWN_LOC/fetch_blast_report_by_index.pl"
c_extract_orf_seq_by_ids="$MYOWN_LOC/extract_orf_sequence_by_ids.pl"

blastx_report=$arg_input_working_dir/blastx.bls
blastx_index=$arg_input_working_dir/blastx.index

evd_plot_feat_homo=${arg_input_evd_plot_feat_base}.homo
evd_plot_feat_orf=${arg_input_evd_plot_feat_base}.orf

ff_seq=$arg_working_dir/ff.fa

# Output1: Homo evident
cat $evd_plot_feat_homo | awk "\$1 == \"$arg_input_query_id\"" > $arg_output_file

# Output2: BLASTX -- append
echo $arg_input_query_id | perl -w $c_fetch_blast_report $blastx_report $blastx_index >> $arg_output_file

# Output3: ORF
cat $evd_plot_feat_orf | awk "\$1 == \"$arg_input_query_id\"" >> $arg_output_file

# Output4: ORF sequence
cat $arg_input_working_dir/ff.fa | perl -w $c_extract_orf_seq_by_ids $arg_input_query_id >> $arg_output_file
