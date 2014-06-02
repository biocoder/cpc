
1) Introduction

Coding Potential Calculator (CPC) is a Support Vector Machine-based
classifier to assess the protein-coding potential of a transcript (i.e
whether a cDNA/RNA transcript could encode a peptide or not) based on
six biologically meaningful sequence features. It takes nucleotide
FASTA sequences as input, and generate output about the coding status
and the "supporting evidence" for the sequence.

2) Pre-requisite:

a. NCBI BLAST package: a local version could be downloaded from
http://www.ncbi.nlm.nih.gov/blast/

b. A relatively comprehensive protein database. UniRef90 and NCBI nr
should be both okay.  
The database should be named as "prot_db", and put under the data/
subdir.

3) Install

a. Unpack the tarball:

tom@linux$ gzip -dc cpc-0.9-r2.tar.gz | tar xf -

b. Build third-part packages: 

tom@linux$ cd cpc-0.9-r2
tom@linux$ export CPC_HOME="$PWD"
tom@linux$ cd libs/libsvm
tom@linux$ gzip -dc libsvm-2.81.tar.gz | tar xf -
tom@linux$ cd libsvm-2.81
tom@linux$ make clean && make
tom@linux$ cd ../..
tom@linux$ gzip -dc estate.tar.gz | tar xf -
tom@linux$ cd estate
tom@linux$ make clean && make

c. Format BLAST database, named it as "prot_db", and put under the
cpc/data/.

tom@linux$ cd $CPC_HOME/data
tom@linux$ formatdb -i (your_fasta_file) -p T -n prot_db

4) Run the predict

tom@linux$ cd $CPC_HOME
tom@linux$ bin/run_predict.sh (input_seq) (result_in_table) (working_dir) (result_evidence)

See the website for tutorial and more details. (http://cpc.cbi.pku.edu.cn)

Contact: cpc@mail.cbi.pku.edu.cn
