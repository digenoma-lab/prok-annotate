#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { prokka } from './modules/prokka'
include { eggnog_mapper } from './modules/eggnog_mapper'
include { kofamscan } from './modules/kofamscan'

workflow {
    
    Channel
        .fromPath( params.genomes )
        .map { file -> tuple(file.baseName, file) }
        .set { genomes_ch }

    prokka(genomes_ch)

    if ( params.run_eggnog ) {
        eggnog_db = file(params.eggnog_db, type: 'dir', checkIfExists: true)
        eggnog_mapper(prokka.out.faa, eggnog_db)
    }
    
    if ( params.run_kofamscan ) {
        kofamscan_db = file(params.kofamscan_db, type: 'dir',
            checkIfExists: true)
        kofamscan(prokka.out.faa, kofamscan_db)
    }
}
