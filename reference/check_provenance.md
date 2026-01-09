# Check whether an object is from a given database and complete appropriate messaging

Check whether an object is from a given database and complete
appropriate messaging

## Usage

``` r
check_provenance(
  obj,
  db,
  altfunc = "fetch",
  altfunc_suffix = NULL,
  objtype = "IDs",
  call = rlang::caller_env()
)
```

## Arguments

- obj:

  The object to check.

- db:

  The database which the object should be from.

- altfunc:

  The function name stub (e.g. "fetch", used for messaging). If `NULL`,
  suppresses alternate function suggestion.

- altfunc_suffix:

  The function name suffix (e.g. "chunked", used for messaging).

- objtype:

  The type of object (used for messaging).

- call:

  The env from which this was called (defaults to the direct caller).
