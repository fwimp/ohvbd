# search_vd_smart handles malformed requests

    Code
      search_vd_smart("SpeciesName", "nonexistent", "ricinus")
    Message
      ! Operator "nonexistent" not an allowed operator!
      -- Allowed operators -----------------------------------------------------------
      * contains
      * !contains
      * equals
      * !equals
      * starts
      * !starts
      * in
      * !in
      * greater
      * less
      --------------------------------------------------------------------------------
      ! Defaulting to "contains"
      ! Debug option "ohvbd_dryrun" is TRUE.
      i Returning request object...
    Output
      <httr2_request>
      GET https://vectorbyte.crc.nd.edu/portal/api/vecdynbyprovider?format=json&field=SpeciesName&operator=contains&term=ricinus
      Body: empty
      Options:
      * useragent: "ROHVBD"

