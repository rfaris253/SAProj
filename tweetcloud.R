library(tidytext)
library(janeaustenr)
library(dplyr)
library(stringr)
library(twitteR)


#setup with authentication key for twitter API
consumer_key <- 'eZPpCGjwmbZTV8hH0BIAk74pv'
consumer_secret <- 'PLRTEqmDo2Tog32uvpUFL72P64TNR2BLfKepgefcQLJlI2jgig'
access_token <- '915228318173102081-3iAy2xUbmZVm8MREvXxqgp1o7WHF5h4'
access_secret <- 'bgqJKoZhUXOAso2od4PuzirrmZodOsGRhLj8geq8fMwA2'
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

make_word_cloud <- function(query,num_tweets,since,noRetweets=TRUE,resultType="recent"){
  
  #get current date and yesterday
  #need to correct for difference in date for UTC still
  until <- Sys.Date()
  since <- currentDate - since
  
  # filters out retweets
  if (noRetweets = TRUE){query <- paste(query,'-filter:retweets')}
  
  #search twitter function from TwitteR makes tweets into data frame
  data <- twListToDF(searchTwitter(query, since=toString(since),until=toString(until), n=num_tweets, resultType=resultType,lang='en'))
  
  #turn it into a data frame for tidy
  data <- data_frame(tweetNumber = 1:nrow(data), tweet = data[,1])
  
  #Make custom stop words that appear enough falsely
  #observe: done by binding rows, could be useful in future 
  custom_stop_words <- bind_rows(data_frame(word = c("https", query), lexicon = c("custom")), stop_words)
  
  #unnest the tokens (words).  Separate tweets into individual words
  data <- data %>%
    unnest_tokens(word, tweets)
  
  #get rid of all stop words.  Extra words
  data <- data %>%
    anti_join(custom_stop_words)
  
  #get rid of all non-alphanumeric characters in tweets
  for(i in 1:nrow(data)){data[i,2] <- str_replace_all(data[i,2], "[^[:alnum:]]", " ")}
  
  #get list of sentiments from base nrc that are negative
  nrcjoy <- get_sentiments("nrc")
  
  #inner join sentiment list with all tweets
  unnestedTwitter %>%
    inner_join(nrcjoy) %>%
    count(word, sentiment, sort = TRUE) %>%
    ungroup()
  
  
  
  
  #wordcloud making, better with more words
  library(wordcloud)
  unnestedTwitter %>%
    count(word) %>%
    with(wordcloud(word, n, max.words = 100))

}