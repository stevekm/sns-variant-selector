# sns Variant Selector

Workflow to collect variants from multiple sns analysis annotation outputs for a list of samples into a single table

# Usage

- Create a file with paths to all of your sns analysis annotation output files (update this to match your criteria), filtered by the contents of `results_dirs.txt` file (known 'good' runs to use)

```
find-annot.sh
```

- Put your list of sample IDs in the `samples.txt` file

- Run the Nextflow pipeline to aggregate the results and filter just for the desired samples, then aggregate into a single table. 

```
make
```

# Software Requirements

- Java 8 (Nextflow)

- Python 2.7/3+
