nextflow.preview.dsl=2

binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/cistopic/bin/" : ""

process SC__CISTOPIC__SELECT_MODELS {

    container params.sc.cistopic.container
    publishDir "${params.global.outdir}/data/intermediate", mode: 'symlink'
    clusterOptions "-l nodes=1:ppn=${params.global.threads} -l walltime=1:00:00 -A ${params.global.qsubaccount}"

    input:
        tuple val(sampleId), path(f)

    output:
        tuple val(sampleId), path("${sampleId}.SC__CISTOPIC__BUILD_MODELS.cistopic_rds")
        path("SC__CISTOPIC__SELECT_MODELS.pdf")

    script:
        def sampleParams = params.parseConfig(sampleId, params.global, params.sc.cistopic.select_models)
		processParams = sampleParams.local
        """
        ${binDir}select_models.R \
            --input ${f} \
            --select ${processParams.select} \
            --output ${sampleId}.SC__CISTOPIC__SELECT_MODELS.cistopic_rds
        """
}

