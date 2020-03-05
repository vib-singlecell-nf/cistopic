nextflow.preview.dsl=2

binDir = !params.containsKey("test") ? "${workflow.projectDir}/src/cistopic/bin/" : ""

process SC__CISTOPIC__BUILD_MODELS {
    
    container params.sc.cistopic.container
    publishDir "${params.global.outdir}/data/intermediate", mode: 'symlink'
    clusterOptions "-l nodes=1:ppn=${params.global.threads} -l walltime=1:00:00 -A ${params.global.qsubaccount}"

    input:
        tuple val(sampleId), path(f)

    output:
        tuple val(sampleId), path("${sampleId}.SC__CISTOPIC__CREATE_OBJECT.cistopic_rds")

    script:
        def sampleParams = params.parseConfig(sampleId, params.global, params.sc.cistopic.build_models)
		processParams = sampleParams.local
        """
        ${binDir}build_models.R \
            --input ${f} \
            --topic ${processParams.topics_to_test} \
			${'--seed ' + (params.global.containsKey('seed') ? params.global.seed: params.seed)} \
            --num_workers ${processParams.num_workers} \
            --alpha ${processParams.alpha} \
            --beta ${processParams.beta} \
            --num_iterations ${processParams.num_iterations} \
            --output ${sampleId}.SC__CISTOPIC__CREATE_OBJECT.cistopic_rds
        """
}

