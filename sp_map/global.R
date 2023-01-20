librarian::shelf(
  dplyr, fs, googleCloudStorageR, glue, here, leaflet, offhabr, readr, sf, shiny, stringr, tidyr)
redo_gcs_csv <- F
options(readr.show_col_types = F)

gcs_csv <- here("data/sp-map_cog-tif.csv")
spp_csv <- here("data/taxa_wm.csv")

d_spp <- read_csv(spp_csv)

# google cloud storage
if (!file.exists(gcs_csv) | redo_gcs_csv){
  Sys.setenv(
    "GCS_DEFAULT_BUCKET" = "offhab_lyrs",
    "GCS_AUTH_FILE"      = "/share/offhab-google-service-account_09e7228ac965.json")

  gcs_auth(Sys.getenv("GCS_AUTH_FILE"))
  gcs_global_bucket("offhab_lyrs")
  d_gcs <- gcs_list_objects()
  write_csv(d_gcs, gcs_csv)
}

d_gcs_spp <- read_csv(gcs_csv) |>
  rename(
    gcs_tif  = name) |>
  mutate(
    gcs = path_ext_remove(gcs_tif)) |>
  separate(
    gcs, c("ds_key", "aphia_id", "lyr_type"),
    sep = "_", extra = "merge", fill = "right") |>
  mutate(
    aphia_id = as.integer(aphia_id)) |>
  filter(
    !is.na(aphia_id),
    lyr_type == "rel") |>
  left_join(
    d_spp, by = "aphia_id") |>
  arrange(scientificname)

bb <- st_bbox(oh_zones_s1k) |> as.vector()
