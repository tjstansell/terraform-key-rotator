locals {
  #
  # formatdate() can't tell me which day of the year we're in, so we have
  # to calculate it ourselves.  We also don't use `time_static` to convert
  # this to a unix time because that would cause a proposed "change" in
  # every plan that uses this module.  That's needlessly noisy and
  # intrusive.
  #
  # Further reading at https://github.com/hashicorp/terraform/issues/31751
  #
  prev_days = [
    0,                                                    #  0 = invalid
    0,                                                    #  1 = Jan = none previous
    31,                                                   #  2 = Feb = sum(Jan)
    31 + 28,                                              #  3 = Mar = sum(Jan-Feb)
    31 + 28 + 31,                                         #  4 = Apr = sum(Jan-March)
    31 + 28 + 31 + 30,                                    #  5 = May = sum(Jan-April)
    31 + 28 + 31 + 30 + 31,                               #  6 = Jun = sum(Jan-May)
    31 + 28 + 31 + 30 + 31 + 30,                          #  7 = Jul = sum(Jan-June)
    31 + 28 + 31 + 30 + 31 + 30 + 31,                     #  8 = Aug = sum(Jan-July)
    31 + 28 + 31 + 30 + 31 + 30 + 31 + 31,                #  9 = Sep = sum(Jan-Aug)
    31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30,           # 10 = Oct = sum(Jan-Sept)
    31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31,      # 11 = Nov = sum(Jan-Oct)
    31 + 28 + 31 + 30 + 31 + 30 + 31 + 31 + 30 + 31 + 30, # 12 = Dec = sum(Jan-Nov)
  ]

  now               = plantimestamp()
  now_year          = tonumber(formatdate("YYYY", local.now))
  now_month         = tonumber(formatdate("M", local.now))
  now_days_in_month = tonumber(formatdate("D", local.now))
  now_days_to_month = local.prev_days[local.now_month]
  now_days_to_year  = 365 * local.now_year

  start_epoch_day  = floor(time_static.start.unix / 86400)
  now_epoch_day    = local.now_days_to_year + local.now_days_to_month + local.now_days_in_month
  days_since_start = now_epoch_day - start_epoch_day

  interval = floor(local.days_since_start / var.rotation_days)
  active   = (local.interval % 2) == 0 ? "A" : "B"
  offsetA  = (local.interval - (local.active == "A") ? 0 : 1) * var.rotation_days
  offsetB  = (local.interval - (local.active == "B") ? 0 : 1) * var.rotation_days

  #                  |
  # A...... ......A..|.. .....A
  #        B...... ..|...B..... .....B
  #          B.... ..|...B..... .....B
  # 12345671234567123456712345671234567
  #
  # days_since_start = 0
  # interval         = 0
  # active           = "A"
  # offsetA          = (0 - 0) * 7 = 0
  # offsetB          = (0 - 1) * 7 = -7
  #
  # days_since_start = 17
  # interval         = floor(17/7) = floor(2.42) = 2
  # active           = "A"
  # offsetA          = (2 - 0) * 7 = 14
  # offsetB          = (2 - 1) * 7 = 7
  #
  # days_since_start = 21
  # interval         = floor(21/7) = floor(3) = 3
  # active           = "B"
  # offsetA          = (3 - 1) * 7 = 14
  # offsetB          = (3 - 0) * 7 = 21
}

resource "time_static" "start" {}

resource "time_offset" "A" {
  base_rfc3339 = time_static.start.rfc3339
  offset_days  = local.offsetA
}

resource "time_offset" "B" {
  base_rfc3339 = time_static.start.rfc3339
  offset_days  = local.offsetB
}
