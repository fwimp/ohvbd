In response to the following comments received on 2026-02-05, we have made the noted changes.

> Please provide a link to the used webservices to the description field of your DESCRIPTION file in the form <http:...> or <https:...> with angle brackets for auto-linking and no space after 'http:' and 'https:'.*

- The main website URLs for dependent services have been provided in the description field.

> Please add \value to .Rd files regarding exported methods and explain the functions results in the documentation.

- This was caused in all but one case by (accurate) return values of NULL in the documentation being converted to a blank string by Roxygen2.
- The functions listed have all had their documentation updated to more verbose explanations of the negative return values.
- The one function where this was not the case (`is_cached()`) has had an appropriate return value added.

> You have examples for unexported functions.

- This function (`fetch_vd_counts()`) is now exported.

> Please ensure that your functions do not write by default or in your examples/vignettes/tests in the user's home filespace

- Caching operations now default to `tempdir()` unless a user has set a default cache directory in an option (`ohvbd_cache`).
- A new function has been added to allow users to more easily specify this default location.

This is a resubmission.

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
