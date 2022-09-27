dashboardPage(
  dashboardHeader(
    title = "Offshore Wind Habitat"),
  dashboardSidebar(
    selectInput(
      "sel_brgn", "Region",
      setNames(brgns$brgn, brgns$bregion)),
    hr(),
    uiOutput("ui_type"),
    uiOutput("ui_var"),
    collapsed = F),
  dashboardBody(
    tags$head(tags$link(rel="stylesheet", type="text/css", href="styles.css")),
    leafletOutput("map") ))
