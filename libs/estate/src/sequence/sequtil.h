/****************************************************************\
*  ESTate - Expressed sequence tag analysis tools etc.           *
*  Copyright (C) 1996-1999.  Guy St.C. Slater.                   *
*  All Rights Reserved.                                          *
*                                                                *
*  gslater@hgmp.mrc.ac.uk  http://www.hgmp.mrc.ac.uk/~gslater/   *
*                                                                *
*  This source code is distributed under the terms of the        *
*  GNU General Public License. See the file COPYING for details. *
*                                                                *
*  If you use this code, please keep this notice intact.         *
\****************************************************************/

/* General Sequence Related Utility Functions.
   Guy St.C. Slater..  September 1998.
*/

#ifndef INCLUDED_SEQUTIL_H
#define INCLUDED_SEQUTIL_H

#include "../general/common.h"
#include <stdio.h>

extern unsigned char *global_sequtil_isacgt;
extern unsigned char *global_sequtil_complement;
#define SEQUTIL_FASTA_LINEWIDTH 60

void SEQUTILreverse(char *seq, int len);
void SEQUTILrevcomp(unsigned char *seq, int len);
 int SEQUTILwriteFASTAblock(FILE *fp, char *seq, int len);
BOOLEAN nucleotideGuessSEQUTIL(char *seq);
long SEQUTILclean(char *raw);

#define SEQUTILisacgt(c) global_sequtil_isacgt[c]
#define SEQUTILcomplement(c) global_sequtil_complement[c]

# endif /* INCLUDED_SEQUTIL_H */

