nextflow.enable.dsl=2

// Params:
//     - outdir
process eggnog_mapper {
    tag "${id}"

    publishDir "${params.outdir}/eggnog/${id}" , mode: 'copy'

    input:
    tuple val(id), path(seqs)
    path(eggnog_db)
   
    output:
    path "eggnog*"
   
    script:
    """  
    python /eggnog_mapper/emapper.py \
        -i ${seqs} \
        --output eggnog \
        -m diamond \
        --data_dir ${eggnog_db} \
        --cpu ${task.cpus}
    """
}
