nextflow.preview.dsl=2

//////////////////////////////////////////////////////
//  Import sub-workflows from the modules:

include SC__FILE_CONVERTER from '../utils/processes/utils.nf' params(params)


//////////////////////////////////////////////////////
// Define the workflow

workflow cistopic {

    take:
        data

    main:
        data = SC__FILE_CONVERTER( data )
        //samples = data.map { it -> it[0] }
        data.view()

}

