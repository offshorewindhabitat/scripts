shinyUI(fluidPage(

  titlePanel("Offshore Habitat Species Map"),

  tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),

  fluidRow(
    column(12,

      selectizeInput("sel_sp", "Species", NULL, width="100%"),

      leafletOutput("map") ))
))
