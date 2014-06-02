#!/bin/bash

arg_working_dir=$1
arg_query_id=$2
arg_output_file=$3

MYOWN_LOC=`dirname $0`;         # XXX: some hacking:)
c_fetch_blast_report="$MYOWN_LOC/fetch_blast_report_by_index.pl"

blastx_report=$arg_working_dir/blastx.bls
blastx_index=$arg_working_dir/blastx.index

echo $arg_query_id | perl -w $c_fetch_blast_report $blastx_report $blastx_index > $arg_output_file

