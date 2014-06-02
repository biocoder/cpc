/****************************************************************\
*  ESTate - Expressed sequence tag analysis tools etc.           *
*  Copyright (C) 1996-1999.  Guy St.C. Slater.                   *
*  All Rights Reserved.                                          *
*                                                                *
*  gslater@hgmp.mrc.ac.uk  http://www.hgmp.mrc.ac.uk/~gslater/   *
*                                                                *
*  This source code is distributed under the terms of the        *
*  GNU General Public License. See the file COPYING for details. *
\****************************************************************/

#ifndef INCLUDED_SEQUTIL_C
#define INCLUDED_SEQUTIL_C

#include "sequtil.h"
#include <ctype.h> /* FOR isalpha(), toupper() */

/* 1 IF [ACGTacgt] CHAR, ELSE 0 */
unsigned char *global_sequtil_isacgt = (unsigned char*)
 "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 "\0\1\0\1\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"
 "\0\1\0\1\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0\0\0\0"
 "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
 "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";

unsigned char *global_sequtil_complement = (unsigned char*)
  "----------------------------------------------------------------"
  "-TVGH--CD--M-KN---YSA-BW-R-------TVGH--CD--M-KN---YSA-BW-R------"
  "----------------------------------------------------------------"
  "----------------------------------------------------------------";


void SEQUTILreverse(char *seq, int len){
    register char *a, *z, swap;
    for(a = seq, z = seq+len-1; a < z; a++, z--)
       Swap(*a, *z, swap);
    return;
    }

void SEQUTILrevcomp(unsigned char *seq, int len){
    register unsigned char *a, *z, swap;
    register int pos;
    for(a = seq, z = seq+len-1; a < z; a++, z--){
       swap = global_sequtil_complement[*a];
       *a = global_sequtil_complement[*z];
       *z = swap;
       }
    if(len&1){ /* IF ODD LENGTH, COMPLEMENT THE CENTRAL BASE */
        pos = len>>1;
        seq[pos] = global_sequtil_complement[seq[pos]];
        }
    return;
    }

int SEQUTILwriteFASTAblock(FILE *fp, char *seq, int len){
    register char *p = seq, *pause = p+len-SEQUTIL_FASTA_LINEWIDTH;
    register int total = len+1;
    while(p < pause){ 
        p+=fwrite(p, sizeof(char), SEQUTIL_FASTA_LINEWIDTH, fp);
        fputc('\n', fp);
        total++;
        }
    p+=fwrite(p, sizeof(char), seq+len-p, fp);
    fputc('\n', fp);
    return total;
    }

/* nucleotideGuessSEQUTIL : IF SEQUENCE >= 85% [ACGTN],
                            RETURNS TRUE.
*/
BOOLEAN nucleotideGuessSEQUTIL(char *seq){
    register char *p = seq;
    register int i = 0;
    do {
        switch(*p){
            case 'A': case 'C': case 'G': case 'T': case 'N':
                i++;
                break;
            case '\0':
                return ((20*i) >= (17*(p-seq)));  /* THANX RAS ;) */
            }
        p++;
    } while( TRUE );
    }

/* SEQUTILclean:
   PARSES PLAIN, GCG, FASTA FORMAT SEQUENCES
   RETURNS LENGTH OF CLEANED SEQUENCE.
*/
long SEQUTILclean(char *raw){
    register char *dst, *src = dst = raw;
    do {
        switch(*src){
            case '.':
                if(src[1] != '.')
                    break; /* IF ".." THEN FALL THROUGH */
            case '>':
                while(*src != '\n') src++;
                dst = raw;
                break;
            }
        if(isalpha(*src))
            *dst++ = toupper(*src);
    } while(*src++);
    *dst= '\0';
    return dst-raw;
    }

#ifdef TEST_THIS_MODULE
/* ### TEST CODE ##################################### */

#include <string.h> /* FOR strdup() */

int main(){
    register char *origseq = "ACG";
    register char *dupseq = strdup(origseq);
    SEQUTILrevcomp((unsigned char*)dupseq, strlen(dupseq));
    printf("FW:[%s]\nRC:[%s]\n", origseq, dupseq);
    SEQUTILrevcomp((unsigned char*)dupseq, strlen(dupseq));
    if(strcmp(origseq, dupseq))
        printf("Error - seqs are not the same\n");
    free(dupseq);
    return 0;
    }

/* ### TEST CODE ##################################### */
#endif /* TEST_THIS_MODULE */ 

#endif /* INCLUDED_WORDHOOD_C */

