This is a generic key rotation module for calculating when a pair of keys
should get rotated.  The idea here is to rotate two keys on a schedule,
where each key is "active" for the `rotation_days` number of days.

To visualize this process some, the module gets instanciated and sets the
`START` time.  The module then calculates the proper date at which each
key should become the "active" key.  Each `time_offset` resource changes
at an interval of `$rotate_days * 2`.

For instance, suppose `rotation_days = 7`.  This would be how the offset
values change as terraform evaluates this, each day.

|   DAY#   | A OFFSET | B OFFSET | ACTIVE |
| :------: | :---: | :---: | :---: |
| 0 | 0 | -7 | A |
| 3 | 0 | -7 | A |
| 7 | 0 | 7 | B |
| 10 | 0 | 7 | B |
| 13 | 0 | 7 | B |
| 15 | 14 | 7 | A |
| 18 | 14 | 7 | A |
| 21 | 14 | 21 | B |

The output of this module is a pair of `time_offset` resources, `A` and
`B`.  These are expected to be used to cause the specific key resources
you want to manage to get recreated at the appropriate time.

See examples of using this with `twingate_service_account_key` resources.
