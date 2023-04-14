if (!"librarian" %in% installed.packages())
  install.packages("librarian")
librarian::shelf(
  # glue, here, googleCloudStorageR, htmltools, readr, sf, tidyr, stringr
  dplyr, fs, leaflet,
  ecoquants/offhabr,
  shiny)
# devtools::install_local(here::here("../offhabr"), force = T)
# devtools::load_all(here::here("../offhabr"))

con <- oh_con() # dbDisconnect(con, shutdown=TRUE)

d_spp <- tbl(con, "lyrs") |>
  filter(
    is_ds_prime == TRUE,
    !is.na(aphia_id)) |>
  left_join(
    tbl(con, "taxa_wm"),
    by = "aphia_id") |>
  collect() |>
  rowwise() |>
  mutate(
    gcs_tif        = path_file(path_tif),
    taxa_hierarchy = c(
      kingdom, phylum, class, order,family, scientificname) |>
      paste(collapse = " > ")) |>
  arrange(taxa_hierarchy)
# TODO: taxa_wm: update class; + common_name
# TODO: ds_key per layer
