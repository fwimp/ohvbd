## code to prepare `gidtable` dataset goes here

gidtable <- read.csv(url("https://github.com/pearselab/areadata/raw/main/data/name-matching.csv"))

usethis::use_data(gidtable, overwrite = TRUE, internal = TRUE, compress = "bzip2")
