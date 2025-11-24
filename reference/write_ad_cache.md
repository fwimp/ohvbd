# write data from AREAdata to cache file

write data from AREAdata to cache file

## Usage

``` r
write_ad_cache(
  d,
  path,
  metric = NA,
  gid = NA,
  format = "rda",
  compression_type = "bzip2",
  compression_level = 9
)
```

## Arguments

- d:

  data to write.

- path:

  cache path.

- metric:

  metric downloaded (inferred if not provided).

- gid:

  gid of data (inferred if not provided).

- format:

  format to store data in (currenly unused).

- compression_type:

  type of compression to use when caching.

- compression_level:

  level of compression to use while caching.
