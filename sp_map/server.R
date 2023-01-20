shinyServer(function(input, output, session) {

  output$map <- renderLeaflet({

    req(input$sel_sp)

    # browser()

    d_sp <- d_gcs_spp |>
      filter(scientificname == input$sel_sp)

    cog_url <- glue(
      "https://storage.googleapis.com/offhab_lyrs/{d_sp$gcs_tif}")

    # rel_cog <- glue("/vsicurl/{cog_url}")
    # r_rel <- rast(rel_cog)
    # r_rel
    # plet(r_rel, tiles="Esri.NatGeoWorldMap")

    tiles_url <- glue("https://api.cogeo.xyz/cog/tiles/WebMercatorQuad/{{z}}/{{x}}/{{y}}@2x?url={cog_url}&resampling_method=average&rescale=1,100&return_mask=true&colormap_name=viridis")

    leaflet() |>
      addProviderTiles(providers$Esri.NatGeoWorldMap) |>
      addTiles(
        urlTemplate=tiles_url) |>
      fitBounds(bb[1], bb[2], bb[3], bb[4]) |>
      addLegend(
        pal    = colorNumeric("viridis", 0:100),
        values = c(0,100),
        title  = "% Habitat")

  })
})
