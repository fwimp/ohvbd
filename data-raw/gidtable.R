## code to prepare `gidtable` dataset goes here

gidtable <- read.csv(url("https://github.com/pearselab/areadata/raw/main/data/name-matching.csv"))
gidtable$NAME_0_orig <- gidtable$NAME_0
gidtable$NAME_0 <- gsub(" ", "_", gidtable$NAME_0)

usethis::use_data(gidtable, overwrite = TRUE, internal = TRUE, compress = "bzip2")
