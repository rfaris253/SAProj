library(tidytext)

sentiments

#http://tidytextmining.com/sentiment.html

#The nrc lexicon categorizes words in a binary fashion (“yes”/“no”) 
#into categories of positive, negative, anger, anticipation, disgust, 
#fear, joy, sadness, surprise, and trust.
get_sentiments('nrc')

#The bing lexicon categorizes words in a binary fashion into positive 
#and negative categories. 
get_sentiments('bing')

#The AFINN lexicon assigns words with a score 
#that runs between -5 and 5, with negative scores indicating negative 
#sentiment and positive scores indicating positive sentiment
get_sentiments('afinn')

#validated from TWITTER DATA

#Also packages like coreNLP and cleanNLP, used to find sentiment of sentences instead 
#of just single words

library(janeaustenr)
library(dplyr)
library(stringr)


#We have an array of strings, lets say with rows of tweets, 1 column
twitterData <-c('I love donald Trump very much', 
                'Bitcoin is false #sheeple',
                'Donald Trump Trump Trump',
                'Where did I leave my pasta?',
                'I am sad and angry and sad',
                'hate joy angry fear, wait where is the pasta my boy!',
                'Where am I? its dark and scary in this place?',
                'Magic Johnson was my role model, until his tragedy...',
                'allie is a dog dog dog dog dog dog dog dog') 

#turn it into a data frame for tidy
tidyTwitterData <- data_frame(tweet = 1:length(twitterData), text = twitterData)
tidyTwitterData

#unnest the tokens (words) and get rid of all stop words
unnestedTwitter <- tidyTwitterData %>%
  unnest_tokens(word, text) %>%
  anti_join(custom_stop_words)
unnestedTwitter

#get list of sentiments from base nrc that are negative
nrcjoy <- get_sentiments("nrc")

#inner join sentiment list with all tweets
unnestedTwitter %>%
  inner_join(nrcjoy) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

#Make custom stop words that appear enough falsely
#observe: done by binding rows, could be useful in future
custom_stop_words <- bind_rows(data_frame(word = c("trump"), 
                                          lexicon = c("custom")), 
                               stop_words)


#wordcloud making, better with more words
library(wordcloud)
unnestedTwitter %>%
  count(word) %>%
  with(wordcloud(word, n, max.words = 100))

