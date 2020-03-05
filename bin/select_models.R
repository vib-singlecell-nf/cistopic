#!/usr/bin/env Rscript

print("##################################################")
print("# cisTopic: Selection of the best model #")
print("##################################################")

# Loading dependencies scripts

library("optparse")
parser <- OptionParser(
  prog = "select_models.R",
  description = "Model cis-regulatory topics using Latent Dirichlet Allocation (LDA)."
)

parser <- add_option(
  parser,
  c("-i", "--input"),
  action = "store",
  default = NULL,
  help = "Path to cisTopic RDS object"
)
parser <- add_option(
  parser,
  c("-o", "--output"),
  action = "store",
  default = NULL,
  help = "Output file, cisTopic RDS format"
)

parser <- add_option(
  parser,
  c("--select"),
  action = "store",
  default = "topic selection method ['maximum','perplexity','derivative'], or the specific model to select (e.g., 30)",
  help = "Method to use for best model selection"
)

args <- parse_args(parser)

cat("Parameters: \n")
print(args)

################################################################################

suppressWarnings(library(cisTopic))

cisTopicObject = readRDS(args$input)

# expand the topics input into a numeric vector:
topic = eval(parse(text = args$topic))

# plot:
pdf("SC__CISTOPIC__SELECT_MODELS.pdf", height=6, width=10 )
par(mfrow=c(3,3))
cisTopicObject <- selectModel(cisTopicObject, type='maximum')
cisTopicObject <- selectModel(cisTopicObject, type='perplexity')
cisTopicObject <- selectModel(cisTopicObject, type='derivative')
dev.off()

if(args$select %in% c('maximum','perplexity','derivative')) {
    cisTopicObject <- selectModel(cisTopicObject, type=args$select)
} else if(args$select %in% names(cisTopicObject@models) ) {
    cisTopicObject <- selectModel(cisTopicObject, select=args$select)
} else {
    stop(paste0("Cannot interpret model selection parameter: ", args$select))
}

print(paste0("Selected model with ", nrow(cisTopicObject@selected.model$topics), " topics."))

saveRDS(cisTopicObject,file=args$output)

