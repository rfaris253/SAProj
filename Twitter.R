library(twitteR)

consumer_key <- 'eZPpCGjwmbZTV8hH0BIAk74pv'
consumer_secret <- 'PLRTEqmDo2Tog32uvpUFL72P64TNR2BLfKepgefcQLJlI2jgig'
access_token <- '915228318173102081-3iAy2xUbmZVm8MREvXxqgp1o7WHF5h4'
access_secret <- 'bgqJKoZhUXOAso2od4PuzirrmZodOsGRhLj8geq8fMwA2'
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


trump <- searchTwitter('Trump',n=3000)
data = twListToDF(trump)
