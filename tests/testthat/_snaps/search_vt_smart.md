# search_vt_smart handles malformed requests

    Code
      search_vt_smart("Interactor1Genus", "nonexistent", "Ixodes")
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
      --------------------------------------------------------------------------------
      ! Defaulting to "contains"
      ! Debug option "ohvbd_dryrun" is TRUE.
      i Returning request object...
    Output
      <httr2_request>
      GET https://vectorbyte.crc.nd.edu/portal/api/vectraits-explorer?format=json&field=Interactor1Genus&operator=contains&term=Ixodes
      Body: empty
      Options:
      * useragent: "ROHVBD"

