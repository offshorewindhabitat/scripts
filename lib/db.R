# dependency for aquamapsdata:
librarian::shelf(
  raquamaps/aquamapsdata,
  raquamaps/raquamaps,
  DBI, dplyr, librarian, mapview,
  sf, terra, zeallot)

# downloads about 2 GB of data, approx 10 GB when unpacked
# download_db()
# data(package = "raquamaps")
con_sl <- aquamapsdata::default_db("sqlite")
# /Users/bbest/Library/Application Support/aquamaps/am.db
# dbListTables(con_sl)

con_pg <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname   = "am",
  host     = "localhost",
  port     = 5432)
dbListTables(con_pg)
