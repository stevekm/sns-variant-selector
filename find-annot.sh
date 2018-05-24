#!/bin/bash
set -e

# find /ifs/data/molecpathlab/NGS580_WES/ -mindepth 3 -maxdepth 3 -type f -name "*-annot.all.txt" | grep -f results_dirs.txt > all_annot.txt

printf '' > all_annot.txt
for path in $(find /ifs/data/molecpathlab/NGS580_WES/ -mindepth 3 -maxdepth 3 -type f -name "*-annot.all.txt" | grep -f results_dirs.txt); do
    # /ifs/data/molecpathlab/NGS580_WES/NS17-03/results_2017-05-23_16-58-16/VCF-LoFreq-annot.all.txt
    caller="$(basename "${path}")"
    caller="$(echo "${caller}" | cut -d '-' -f2)"
    runID="$(basename $(dirname $(dirname  "${path}")))"
    resultsID="$(basename $(dirname  "${path}"))"
    printf "${caller}\t${runID}\t${resultsID}\t${path}\n" >> all_annot.txt
done
