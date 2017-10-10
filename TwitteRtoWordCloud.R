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

#get current UTC time as UTC
UTCtime <-Sys.time()
attr(UTCtime, "tzone") <- "UTC" 
UTCtime

#get current date and yesterday
#need to correct for difference in date for UTC still
currentDate <- Sys.Date()
#attr(currentDate, "tzone") <- "UTC" #doesn't work
yesterday <- currentDate -1 
currentDate
yesterday

#number of tweets
n=1000

#search twitter function from TwitteR makes tweets into data frame of n 16 dimension objects
#starts at latest time in time frame, and searches backwards in time
#until it finds n objects(tweets) 
data <- searchTwitter('#MAGA+Trump -filter:retweets', since = toString(yesterday), 
                      until = toString(currentDate), n=n)
data <- twListToDF(data)

#way to get tweet column of data frame
tweetText <-data[1:n,1]

#turn it into a data frame for tidy
tidyTwitterData <- data_frame(tweetNumber = 1:nrow(data), tweets = data[1:n,1])

#Make custom stop words that appear enough falsely
#observe: done by binding rows, could be useful in future
custom_stop_words <- bind_rows(data_frame(word = c("maga","https", "realdonaldtrump", "trump"), 
                                          lexicon = c("custom")), 
                               stop_words)



#get rid of all non-alphanumeric characters in tweets
for(n in 1:1000){
  tidyTwitterData[n,2] <- str_replace_all(tidyTwitterData[n,2], "[^[:alnum:]]", " ")
}

#would be nice to get rid of all @usernames, not just @
#also get rid of URLs, links, etc...



#unnest the tokens (words).  Separate tweets into individual words
unnestedTwitter <- tidyTwitterData %>%
  unnest_tokens(word, tweets)
  
#get rid of all stop words.  Extra words
unnestedTwitter <- unnestedTwitter %>%
  anti_join(custom_stop_words)


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

