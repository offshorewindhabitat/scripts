shinyServer(function(input, output, session) {

  # map ----
  output$map <- renderLeaflet({
    req(input$sel_sp)

    oh_map_cog_sp(
      aphia_id = as.integer(input$sel_sp),
      con = con,
      cog_opacity = 0.8)
  })

  # sel_sp: from URL ----
  observe({
    q <- parseQueryString(session$clientData$url_search)
    if (!is.null(q[['aphia_id']])) {
      updateSelectizeInput(
        session, 'sel_sp',
        choices  = setNames(
          as.character(d_spp$aphia_id),
          d_spp$taxa_hierarchy),
        server   = TRUE,
        selected = q[['aphia_id']])
    }
  })

  # sel_sp: from server ----
  updateSelectizeInput(
    session, 'sel_sp',
    choices = setNames(
      as.character(d_spp$aphia_id),
      d_spp$taxa_hierarchy),
    server = TRUE)

  # url: update from sel_sp
  observe({
    req(input$sel_sp)
    updateQueryString(glue("?aphia_id={input$sel_sp}"))
  })

})
