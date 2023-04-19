# R packages (to deploy on ShinyApps.io)
library(dplyr)
library(fs)
library(leaflet)
library(leaflet.extras)
library(offhabr)  # remotes::install_github("offshorewindhabitat/offhabr", force = T)
library(shiny)

con <- oh_con()   # dbDisconnect(con, shutdown=TRUE)

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

# TODO:
# - taxa_wm: update class; + common_name
# - ds_key per layer
