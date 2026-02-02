# Fuzzy match a term (case-insensitive) to a list of final terms through a translation enum.

Fuzzy match a term (case-insensitive) to a list of final terms through a
translation enum.

## Usage

``` r
.match_term(
  term,
  term_options,
  final_terms,
  default_term = NULL,
  term_name = "metric",
  human_terms = NULL,
  named_options = TRUE,
  call = rlang::caller_env()
)
```

## Arguments

- term:

  A string to match

- term_options:

  A named vector to map input terms to final terms in the form c("term1"
  = index in final_terms). Indices can be duplicated.

- final_terms:

  A vector of final acceptable terms.

- default_term:

  A default term to use if nothing is found. If NULL, errors on no
  match.

- term_name:

  The human name of the term (e.g. metric, operator...).

- human_terms:

  An optional list of acceptable terms for humans to use (may differ
  from final terms but should be present in term_options)

- named_options:

  Whether term_options has been provided as a named vector or merely a
  normal character vector. (Liable to be removed)

- call:

  The env from which this was called (defaults to the direct calling
  environment).

## Value

list where term = matched term & id = index in final_terms
