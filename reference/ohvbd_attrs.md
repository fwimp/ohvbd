# Internal attributes

`ohvbd` uses a number of internal attributes to track data states within
pipelines. Generally these are not designed to be user-modified. They
are, however, listed here for completeness (and curiosity).

It is typically not a good idea to manually modify these attributes
directly unless a helper such as
[`force_db()`](https://ohvbd.vbdhub.org/reference/force_db.md) or
[`ohvbd_db()`](https://ohvbd.vbdhub.org/reference/ohvbd_db.md) is
provided. Even then, modifying these attributes may cause unexpected
errors or data inconsistencies. These errors may not be signalled to the
user by `ohvbd`, and they may not be obvious *or even detectable*.

Be sure when modifying the `db` attribute that the value you set it to
is consistent with the origin of your data, and that the value is a db
known to ohvbd.

## Summary table of attributes

|                  |     |                                                        |                                                                       |
|------------------|-----|--------------------------------------------------------|-----------------------------------------------------------------------|
| Attribute        |     | Description                                            | Object/s                                                              |
| **db**           |     | The database from which the object has been retrieved. | `ohvbd.ids`, `ohvbd.responses`, `ohvbd.data.frame`, `ohvbd.ad.matrix` |
| **metric**       |     | The AD metric.                                         | `ohvbd.ad.matrix`                                                     |
| **gid**          |     | The AD aggregation level.                              | `ohvbd.ad.matrix`                                                     |
| **cached**       |     | Whether the data was loaded from a cache.              | Any                                                                   |
| **writetime**    |     | The time at which a data file was originally cached.   | Any                                                                   |
| **query**        |     | The search query sent to the Hub.                      | `ohvbd.hub.search`                                                    |
| **searchparams** |     | Any extra parameters sent to the Hub.                  | `ohvbd.hub.search`                                                    |

*Note: (AD = AREAdata)*

## db

*Type: string*

The **db** attribute indicates to `ohvbd` where an object originated. It
is used to determine appropriate method dispatch (such as with
[`fetch()`](https://ohvbd.vbdhub.org/reference/fetch.md)) and to check
that pipelines are sensible constructed.

## metric

*Type: string*

**metric** signifies what AD metric the matrix contains. It is
predominantly (but not exclusively) used for formatting and caching.

## gid

*Type: integer*

**gid** represents the spatial scale of data from AD. It is used for a
variety of spatial operations.

## cached

*Type: boolean*

**cached** objects receive this flag at write-time. It sticks with the
object when it is reloaded, and is mostly used for UI/UX purposes.

## writetime

*Type: POSIXct*

**writetime** stores the time at which a cached object (that is likely
to become stale) was written to the cache.

## query

*Type: string*

Simply stores the base **query** that was sent to the
[vbdhub](https://vbdhub.org) search API.

## searchparams

*Type: named list*

A record of any other search parameters that were sent to the
[vbdhub](https://vbdhub.org) search API (e.g. species IDs etc.).

## Author

Francis Windram
