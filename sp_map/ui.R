shinyUI(fluidPage(

  titlePanel("OffHab Species Maps"),

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
