# snippy_full_to_subset_csv
Takes a snippy.full.aln and subsets it by a list of isolate names and genomic positions (single chromosome only)

```

snippy-clean_full_aln [test.full.aln] > [test.full.clean.aln]

sh snippy_full_to_subset_csv.sh [test.full.clean.aln] [FOFN.txt] [POS_FILE.txt] [OUTFILE.csv]

```
