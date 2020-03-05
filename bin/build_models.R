#!/usr/bin/env Rscript

print("##################################################")
print("# cisTopic: Building the models #")
print("##################################################")

# Loading dependencies scripts

library("optparse")
parser <- OptionParser(
  prog = "build_models.R",
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
  c("-n", "--topic"),
  action = "store",
  default = "c(2, 5, 10:25, 30, 35, 40)",
  help = "Test models with this number of topics"
)
parser <- add_option(
  parser,
  c("--num_iterations"),
  action = "store",
  default = 500,
  help = "Number of iterations to use"
)
parser <- add_option(
  parser,
  c("--alpha"),
  action = "store",
  default = 50,
  help = "Dirichlet hyperparameter alpha affects the topic-cell contributions"
)
parser <- add_option(
  parser,
  c("--beta"),
  action = "store",
  default = 0.1,
  help = "Dirichlet hyperparameter beta affects the region combinations"
)

parser <- add_option(
  parser,
  c("-s", "--seed"),
  action = "store",
  default = 0,
  help = "Use this integer seed for reproducibility."
)
parser <- add_option(
  parser,
  c("--num_workers"),
  action = "store",
  default = 1,
  help = "Number of processors to use"
)

args <- parse_args(parser)

cat("Parameters: \n")
print(args)

################################################################################

suppressWarnings(library(cisTopic))

cisTopicObject = readRDS(args$input)

# expand the topics input into a numeric vector:
topic = eval(parse(text = args$topic))

cisTopicObject <- runWarpLDAModels(cisTopicObject, 
                                   topic = topic,
                                   seed = args$seed,
                                   alpha = args$alpha,
                                   beta = args$beta,
                                   nCores = args$num_workers,
                                   iterations = args$num_iterations,
                                   addModels = FALSE)

#cisTopicObject <- runWarpLDAModels(cisTopicObject, 
#                                   topic = args$topic,
#                                   seed = args$seed,
#                                   nCores = args$num_workers,
#                                   iterations = args$iterations,
#                                   addModels = FALSE)

                                   # topic=c(2, 5, 10:25, 30, 35, 40), 
saveRDS(cisTopicObject,file=args$output)

