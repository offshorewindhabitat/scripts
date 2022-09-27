shinyServer(function(input, output, session) {

  vals <- reactiveValues(
    brgn = "_over")

  output$ui_type <- renderUI({
    if (input$sel_brgn == "_over")
      return("")
    selectInput("sel_type", "Type", types)
  })

  output$ui_var <- renderUI({
    if (input$sel_brgn == "_over")
      return("")

    req(input$sel_type)
    if (input$sel_type == "sum")
      return(selectInput("sel_var", "Variable", vars_sum, selected = "prod"))

    # otherwise: input$sel_type == "spp"
    d_spp <- d_rgn_spp %>%
      filter(brgn == input$sel_brgn)
    selectInput("sel_sp", "Species", setNames(d_spp$sp_key, d_spp$sp_lbl))
  })

  output$map <-  renderLeaflet({

    # input <- list(sel_brgn = "cgmx", sel_var = "biomass")
    # brgn     <- input$sel_brgn
    # brgn_lbl <- names(brgns)[brgns==brgn]
    # var      <- input$sel_var
    # var_lbl  <- names(vars)[vars==var]
    # var_tif  <- glue("{dir_tif}/_{var}_{brgn}.tif")
    #
    # ply_brgn <- ply_brgns %>%
    #   filter(rgn == brgn_lbl)
    # ply_notbrgn <- ply_brgns %>%
    #   filter(rgn != brgn_lbl)
    #
    # stopifnot(file.exists(var_tif))
    #
    # r   <- raster(var_tif)
    # b   <- st_bbox(extent(projectExtent(r, crs = 4326)))
    # TODO: transform cubed raster back
    # r_v <- values(r)
    # pal <- colorNumeric(
    #   "Spectral", r_v,
    #   reverse = T, na.color = "transparent")
    # clr_brgn <- function(x){
    #   browser()
    #   ifelse(is.na(x), "gray", "blue")
    # }

    leaflet() %>%
      addProviderTiles(
        providers$Esri.OceanBasemap,
        options = providerTileOptions(
          opacity = 0.5)) %>%
      addPolygons(
        data = ply_brgns, layerId = as.vector(ply_brgns$brgn),
        color = "gray", opacity = 0.7, weight = 1,
        fillColor = ~pal_brgns(brgn), fillOpacity = 0.5)

    # addRasterImage(
    #   r, project = F,
    #   colors = pal, opacity=0.6) %>%
    # addPolygons(
    #   data = ply_notbrgn,
    #   color = "black", weight = 1,
    #   fill = F) %>%
    # addPolygons(
    #   data = ply_brgn,
    #   color = "black", weight = 4,
    #   fill = F) %>%
    # addLegend(
    #   pal = pal, values = r_v,
    #   title = var_lbl) %>%
    # fitBounds(b[['xmin']], b[['ymin']], b[['xmax']], b[['ymax']])

  })

  observe({
    # change region from drop-down
    req(input$sel_brgn)
    req(input$sel_brgn != vals$brgn)

    message(glue("input$sel_brgn ({input$sel_brgn}) != vals$brgn ({vals$brgn})"))
    brgn <- vals$brgn <- input$sel_brgn

    if (brgn == "_over"){
      b <- st_bbox(ply_brgns)

      leafletProxy("map") %>%
        clearShapes() %>%
        addPolygons(
          data = ply_brgns, layerId = as.vector(ply_brgns$brgn),
          color = "gray", opacity = 0.7, weight = 1,
          fillColor = ~pal_brgns(brgn), fillOpacity = 0.5) %>%
      flyToBounds(b[['xmin']], b[['ymin']], b[['xmax']], b[['ymax']])

    } else {
      ply_brgn <- ply_brgns %>%
        filter(brgn == !!brgn)
      b <- st_bbox(ply_brgn)

      leafletProxy("map") %>%
        clearShapes() %>%
        addPolygons(
          data = ply_brgn,
          color = "black", weight = 4,
          fill = F) %>%
        flyToBounds(b[['xmin']], b[['ymin']], b[['xmax']], b[['ymax']])
    }
  })

  observe({
    # fill out region with raster
    req(input$sel_brgn)
    req(input$sel_brgn != "_over")
    req(input$sel_type)

    # input <- list(sel_brgn = "cgmx", sel_var = "biomass")
    brgn     <- input$sel_brgn
    bregion  <- brgns %>% filter(brgn == !!brgn) %>% pull(bregion)

    if (input$sel_type == "sum"){
      req(input$sel_var)
      message(glue("input$sel_var: {input$sel_var}"))
      var      <- input$sel_var
      variable <- names(vars_sum)[vars_sum==var]
      var_tif  <- glue("{dir_tif}/_{var}_{brgn}.tif")
    } else {
      # input$sel_type == "spp"
      req(input$sel_sp)
      req(input$sel_brgn == vals$brgn)

      message(glue("input$sel_sp: {input$sel_sp}; input$sel_brgn: {input$sel_brgn}"))

      d_sp <- d_rgn_spp %>%
        filter(
          brgn   == input$sel_brgn,
          sp_key == input$sel_sp)
      var_tif  <- d_sp$tif
      variable <- glue("{str_replace(d_sp$sp_lbl, '\n', '<br>')}<br>∛kg per tow")
    }

    req(file.exists(var_tif))

    message(glue("var_tif: {var_tif}"))
    r   <- raster(var_tif)
    # b   <- st_bbox(extent(projectExtent(r, crs = 4326)))
    # TODO: transform cubed raster back
    r_v <- values(r)
    pal <- colorNumeric(
      "Spectral", r_v,
      reverse = T, na.color = "transparent")

    leafletProxy("map") %>%
      clearImages() %>%
      clearControls() %>%
      addRasterImage(
        r, project = F,
        colors = pal, opacity=0.6) %>%
      addLegend(
        pal = pal, values = r_v,
        title = variable)
  })

  observe({
    # click new region on map from overview
    brgn <- input$map_shape_click$id
    req(brgn)

    if (!is.null(brgn)){
      updateSelectInput(
        session, "sel_brgn", selected = brgn)
    }
  })

})
