nextflow.preview.dsl=2

//////////////////////////////////////////////////////
//  Import sub-workflows from the modules:

include SC__FILE_CONVERTER from '../utils/processes/utils.nf' params(params)

include SC__CISTOPIC__BUILD_MODELS from './processes/build_models.nf' params(params)
include SC__CISTOPIC__SELECT_MODELS from './processes/select_models.nf' params(params)

//////////////////////////////////////////////////////
// Define the workflow

workflow cistopic {

    take:
        data

    main:
        data = SC__FILE_CONVERTER( data )
        data.view()

       SC__CISTOPIC__BUILD_MODELS(data) |
           SC__CISTOPIC__SELECT_MODELS

}

