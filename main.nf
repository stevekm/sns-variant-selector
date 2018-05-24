params.output_dir = "output"
params.all_annot_file = "all_annot.txt"
Channel.fromPath(params.all_annot_file)
        .splitCsv(sep: "\t")
        .map { caller, runID, resultsID, annot_path ->
            def new_caller
            def annot_file = file(annot_path)
            if ( caller == 'GATK' ) {
                new_caller = 'HaplotypeCaller'
            } else {
                new_caller = caller
            }
            return([ new_caller, runID, resultsID, annot_file ])
        }
        .into { annot_inputs; annot_inputs2 }

Channel.fromPath("samples.txt").set { samples_list }

// annot_inputs2.subscribe { println "[annot_inputs2] ${it}" }

process update_annot_table {
    publishDir "${params.output_dir}/update_annot_table", overwrite: true
    tag "${prefix}"

    input:
    set val(caller), val(runID), val(resultsID), file(annot_file) from annot_inputs

    output:
    file(output_file) into updated_tables

    script:
    prefix = "${caller}.${runID}.${resultsID}"
    output_file = "${prefix}.annotations.tsv"
    """
    echo "${annot_file}"
    paste-col.py -i "${annot_file}" --header Run --value "${runID}" | \
    paste-col.py --header Results --value "${resultsID}" | \
    paste-col.py --header VariantCaller --value "${caller}" > \
    "${output_file}"
    """
}

updated_tables.collect()
            .map{ items ->

                return( [items] )
            }
            .combine(samples_list)
            .set { tables_samples }

process concat_tables {
    publishDir "${params.output_dir}/", overwrite: true, mode: "copy"
    echo true

    input:
    set file(all_tables: "*"), file(samples_list) from tables_samples

    output:
    file("all_sample_annotations.tsv")
    file("all_sample_annotations.zip")

    script:
    """
    concat-tables.py ${all_tables} | head -1 > all_sample_annotations.tsv
    concat-tables.py ${all_tables} | grep -f "${samples_list}" >> all_sample_annotations.tsv
    zip all_sample_annotations.zip all_sample_annotations.tsv
    """
}
