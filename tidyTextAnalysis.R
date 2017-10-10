library(tidytext)
library(dplyr)
library(janeaustenr)
library(stringr)
library(ggplot2)


original_books <- austen_books() %>%
  group_by(book) %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  ungroup()

original_books

#need to convert this to one-toden-per-document-per-row
#need to split the text into individual tokens, this is done by unnest_tokens
#operating on text

tidy_books <- original_books %>%
  unnest_tokens(word, text) 

#stop_words gets rid of unnecessary words

tidier_books <- tidy_books %>%
  anti_join(stop_words)
tidier_books

#count the most frequent words
tidier_counted_books <-tidier_books %>%
  count(word, sort = "TRUE")

#visualize on ggplot
tidier_books%>%
  count(word, sort = "TRUE") %>%
  filter(n > 500) %>%
  mutate(word, reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
