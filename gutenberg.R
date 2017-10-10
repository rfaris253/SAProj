library(tidytext)
library(dplyr)
library(janeaustenr)
library(stringr)
library(ggplot2)
library(gutenbergr)

#find gutenberg ids
gutenberg_metadata %>%
  filter(title == "Wuthering Heights")

#just english, readable, no duplicate ids
gutenberg_works(author == "Austen, Jane")

#specific search
gutenberg_works(str_detect(author, "Austen"))

#download by ID
id <- gutenberg_works(author == "Austen, Jane")
id[[1]]
books <-gutenberg_download(id)

book
#TIDY TIME

words <- book %>%
  unnest_tokens(word, text)

tidywords <- words %>%
  anti_join(stop_words)

tidywords

#count the most frequent words
countedtidywords <-tidywords %>%
  count(word, sort = "TRUE")

countedtidywords

#plot that ish
countedtidywords%>%
  filter(n > 50) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
