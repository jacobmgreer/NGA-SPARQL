required <- c("WikidataQueryServiceR", "tidyverse", "magrittr", "tools", "lubridate")
lapply(required, require, character.only = TRUE)

options(readr.show_col_types = FALSE)

details <- grep(list.files("output/artist"), pattern='P2252', invert=TRUE, value=TRUE)

for (i in details) {
  col <- file_path_sans_ext(basename(i))
  query <-
    read_csv(paste0("output/artist/", i)) %>%
    rename(QID = item) %>%
    mutate(QID = basename(QID)) %>%
    group_by(QID) %>%
    reframe(detail = str_c(str_c('"', detail, '"'), collapse = ","))
  colnames(query)[colnames(query) == "detail"] = col
  assign(col, query)
}

Artists <-
  read_csv("output/artist/P2252.csv") %>%
  mutate(QID = basename(item)) %>%
  select(-item) %>%
  select(QID, everything()) %>%
  left_join(P1196, by="QID") %>%
  left_join(P19, by="QID") %>%
  left_join(P20, by="QID") %>%
  left_join(P21, by="QID") %>%
  left_join(P27, by="QID") %>%
  left_join(P509, by="QID") %>%
  left_join(P569, by="QID") %T>%
  write.csv(., "output/artists.csv", row.names = FALSE)

rm(list=ls(pattern="^P"))
rm(details, required, i, query, col, artist.values)
