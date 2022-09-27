librarian::shelf(
  dplyr, glue, here, leaflet, mapview, purrr,
  RColorBrewer, readr, raster, sf, stringr,
  shiny, shinydashboard, tidyr)
select = dplyr::select
options(readr.show_col_types = F)

brgns_csv <- here("data/boem_regions.csv")
if (!file.exists(brgns_csv)){
  brgns <- c(
    `Washington/Oregon`      = "waor",  # light green
    `Southern California`    = "scal",  # dark green
    `North Atlantic`         = "natl",  # light blue
    `Mid Atlantic`           = "matl",  # dark blue
    `Central Gulf of Mexico` = "cgmx")  # pink
  tibble(
    brgn    = c(unname(brgns), "_over"),
    bregion = c(names(brgns), "Overview"),
    color   = c(brewer.pal(length(brgns), "Paired"), "gray")) %>%
    arrange(brgn) %>%
    write_csv(brgns_csv)
}
brgns <- read_csv(brgns_csv) %>%
  arrange(brgn) %>%
  mutate(
    brgn = factor(brgn))
pal_brgns <- colorFactor(
  palette = brgns$color,
  domain  = brgns$brgn)

ply_brgns_geo <- here("data/ply_boem_rgns_smpl100m.geojson")
# read_sf(here("data/ply_boem_rgns.geojson")) %>%
#   st_simplify(preserveTopology = T, dTolerance = 100) %>%
#   write_sf(ply_brgns_geo)
levels(brgns$bregion)
ply_brgns <- read_sf(ply_brgns_geo) %>%
  mutate(
    bregion = rgn,
    brgn    = setNames(brgns$brgn, brgns$bregion)[rgn]) %>%
  select(brgn, bregion)
types <- c(
  `Regional summary`   = "sum",
  `Individual species` = "spp")
vars_sum <- c(
  `Biomass sum (∛kg per tow)`       = "sum-biomass",  # TODO: units
  `Species richness (# of species)` = "nspp",
  `Product: biomass * richness`     = "prod")

dir_tif <- "~/My Drive/projects/offhab/data/oceanadapt.rutgers.edu/data_tif"
spp_csv <- file.path(dir_tif, "_spp.csv")

d_rgn_spp <- tibble(
  csv = list.files(dir_tif, "_spp-cellstats_.*.csv", full.names = T),
  df = map(csv, read_csv)) %>%
  unnest(df) %>%
  mutate(
    tif = glue("{dir_tif}/{brgn}_{sp_key}_{yr}.tif")) %>%
  left_join(
    read_csv(spp_csv),
    by = "sp_key") %>%
  mutate(
    sp_lbl = glue("{sp_sci}\n({sp_cmn})")) %>%
  arrange(brgn, sp_sci)

stopifnot(all(file.exists(d_rgn_spp$tif)))
