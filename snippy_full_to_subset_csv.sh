#!/bin/bash

# Andrew Buultjens 08.2023


#FULL_ALN=tmp.full.clean.aln
#FOFN=tmp_fofn.txt
#POS_FILE=117_POS.csv
#OUTFILE=OUTFILE.csv

FULL_ALN=${1}
FOFN=${2}
POS_FILE=${3}
OUTFILE=${4}

# generate random prefix for all tmp files
RAND_1=`echo $((1 + RANDOM % 100))`
RAND_2=`echo $((100 + RANDOM % 200))`
RAND_3=`echo $((200 + RANDOM % 300))`
RAND=`echo "${RAND_1}${RAND_2}${RAND_3}"`

# index fasta file
samtools faidx ${FULL_ALN}

# loop through all isolates in list
for TAXA in $(cat ${FOFN}); do
	samtools faidx ${FULL_ALN} ${TAXA} | grep -v '>' | tr -d '\n' | tr '-' 'N' | sed "s/$/\n/g" >> ${RAND}_LINES.seq
done

# transpose seq file
sed 's/./&,/g' < ${RAND}_LINES.seq | sed 's/.$//' | tr ',' '\t' | datamash transpose -H | tr -d '\t' > ${RAND}_LINES.tr.seq

# loop through all positions in list
for POS in $(cat ${POS_FILE}); do
	head -${POS} ${RAND}_LINES.tr.seq | tail -1 >> ${RAND}_POS_LINES.tr.seq
done

# make into csv
sed 's/./&,/g' < ${RAND}_POS_LINES.tr.seq | sed 's/.$//' > ${RAND}_POS_LINES.tr.csv

# add header
tr '\n' ',' < ${FOFN} |  sed "s/$/\n/g" | sed 's/.$//' > ${RAND}_HEADER_POS_LINES.tr.csv
cat ${RAND}_POS_LINES.tr.csv >> ${RAND}_HEADER_POS_LINES.tr.csv

# add POS index
echo "INDEX" > ${RAND}_INDEX.csv
cat ${POS_FILE} >> ${RAND}_INDEX.csv
paste ${RAND}_INDEX.csv ${RAND}_HEADER_POS_LINES.tr.csv | tr '\t' ',' > ${RAND}_INDEX_HEADER_POS_LINES.tr.csv

# make outfile
cp ${RAND}_INDEX_HEADER_POS_LINES.tr.csv ${OUTFILE}		

# rm tmp files
rm ${RAND}_*
