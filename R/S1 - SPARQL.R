required <- c("WikidataQueryServiceR", "tidyverse", "magrittr")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

count.artworks <- as.numeric(query_wikidata("SELECT (COUNT(*) as ?cnt) WHERE {?work wdt:P4683 ?nga.}"))
count.artists <- as.numeric(query_wikidata("SELECT (COUNT(*) as ?cnt) WHERE {?work wdt:P2252 ?nga.}"))

NGA.artworks <- NULL
for (i in 1:ceiling(count.artworks / 50000)) {
  NGA.artworks <-
    bind_rows(NGA.artworks,
              query_wikidata(
                sprintf(read_file('SPARQL/P4683 - artworks.sparql'), format((i-1) * 50000, scientific = F))
              )
    )
  message(paste("SPARQL Art", i))
}

write.csv(NGA.artworks, "output/artworks.csv", row.names = FALSE)

artist.values <- list.files("SPARQL/artists", full.names = TRUE)

for (i in artist.values) {
  write.csv(query_wikidata(read_file(i)),
            paste0("output/artist/", gsub( " .*$", "", basename(i)), ".csv"),
            row.names = FALSE)
  message(paste("Artist Details:", i))
}

rm(required, i, artist.values)
