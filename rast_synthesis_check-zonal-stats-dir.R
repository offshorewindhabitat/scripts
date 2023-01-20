librarian::shelf(
  fs, stringr)

dir_zs <- "/Users/bbest/My Drive/projects/offhab/data/_zonal_stats"
rx_csv <- "([a-z]{2})_([0-9]+)_(mean|notNA|area_km2)"
dir_tif <- "/Users/bbest/My Drive/projects/offhab/data/_lyrs"
rx_tif <- "([a-z]{2})_([0-9]+)\\.tif$"
stat <- "area_km2"

d_lyrs <- tibble(
  path_tif = list.files(dir_tif, rx_tif, full.names = T, recursive = T))

d <- dir_info(dir_zs, glob = "*.csv") %>%
  mutate(
    lyr_key   = path_file(path) |> path_ext_remove(),
    ds_key    = str_replace(lyr_key, rx_csv, "\\1"),
    aphia_id  = str_replace(lyr_key, rx_csv, "\\2") %>%
      as.integer(),
    stat      = str_replace(lyr_key, rx_csv, "\\3"))

print(table(d$stat))

t <- d %>%
  filter(stat == !!stat) %>%
  pull(modification_time) %>%
  range()
i <- d %>%
  filter(stat == !!stat) %>%
  nrow()
i_tot <- nrow(d_lyrs)
dt_lyr <- difftime(t[2], t[1], units="secs") / i
i_togo <- i_tot - i
eta <- t[2] + (i_togo * dt_lyr)
message(glue("{stat}: {i}/{i_tot};  {format(dt_lyr, digits=2)} ea;  eta: {eta}"))
