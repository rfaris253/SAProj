library('rvest')

site = read_html('https://www.vocabulary.com/lists/558097')
words=html_nodes(site,".dynamictext") 
wordArray=html_text(words)
definition=html_nodes(site,".definition")
definitionArray=html_text(definition)
definitionArray
wordArray
wordArray=wordArray[-1]
WordsMidSchoolersShouldKnow=matrix(c(wordArray,definitionArray),100,2)
WordsMidSchoolersShouldKnow
