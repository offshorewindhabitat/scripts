shinyUI(fluidPage(

  titlePanel("Old Faithful Geyser Data"),

  sidebarLayout(

    sidebarPanel(
      selectInput(
        "sel_sp",
        "Species",
        d_gcs_spp$scientificname) ),

    mainPanel(
      leafletOutput("map") )

    )
))
