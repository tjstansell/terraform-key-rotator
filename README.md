# Key Rotation with Terraform

This is a generic key rotation module for calculating when a pair of keys
should get rotated.  The idea here is to rotate two keys on a schedule,
where each key is "active" for the `$rotation_days` number of days.

The module gets created and sets an initial `START` time.  The module then
calculates the proper date at which each key should become the "active"
key.  Each `time_offset` resource changes at an interval of
`$rotation_days * 2`, offset from each other by `$rotation_days` days.

For instance, suppose `rotation_days = 7`.  This would be how the offset
values change as terraform evaluates this on different days.

|   DAY#   | A OFFSET | B OFFSET | ACTIVE |
| :------: | :---: | :---: | :---: |
| 0 | 0 | -7 | A |
| 3 | 0 | -7 | A |
| 7 | 0 | 7 | B |
| 10 | 0 | 7 | B |
| 13 | 0 | 7 | B |
| 15 | 14 | 7 | A |
| 20 | 14 | 7 | A |
| 21 | 14 | 21 | B |
| 22 | 14 | 21 | B |

Notice how each offset increases at a rate of `$rotation_days * 2` (in
this case `14`).

The output of this module is a pair of `time_offset` resources, `A` and
`B`, as well as the name of which one is `active`.  These are expected to
be used to cause the specific key resources you want to manage to get
recreated at the appropriate time.

See examples of how to use this in the provider-specific sub-modules:
- [twingate_service_account_key using lifecycle](./twingate/main.tf)
- [google_service_account_key](./google/main.tf)
