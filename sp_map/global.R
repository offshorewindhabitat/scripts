# old packages for dev:
# librarian::shelf(
#   dplyr, fs, leaflet,
#   ecoquants/offhabr,
#   shiny)
# devtools::install_local(here::here("../offhabr"), force = T)
# devtools::load_all(here::here("../offhabr"))

# packages for shinyapps.io
# remotes::install_github("ecoquants/offhabr", force = T)
library(dplyr)
library(fs)
library(leaflet)
library(leaflet.extras)
library(offhabr)
library(shiny)

# devtools::session_info()
# offhabr             * 0.11.0     2023-04-14 [1] Github (ecoquants/offhabr@4ed52d4)
# leaflet             * 2.1.1.9000 2023-01-02 [1] Github (rstudio/leaflet@51daa69)

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
