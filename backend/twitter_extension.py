import tweepy
from textblob import TextBlob
import os
import json

#twitter api variables
ACCESS_TOKEN = '2452116308-nIIZCk8I9Y9VUeSKLgMFWLqre5CYgj72uA1lBfA'
ACCESS_TOKEN_SECRET = 'PG0yO0x3lEMBr22DiGXebc6FBf6iyDTEjIb5pJLfhp7ud'
CONSUMER_KEY = 'mWMxbbR2PFmUE1Bk9WV0l1NPK'
CONSUMER_SECRET = 'DnSsn308le2mQK7UsKNrTMrXb8p6WlskBd0Otalpgtp933QIgI'

#where on earth id for sandiego
WOEID = '2487889'

#limit max number of tweets to get back so to limit number of calls
MAX_TWEETS = 10

auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
auth.set_access_token(ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

#instance of tweepy object
api = tweepy.API(auth)

#gets the trending names based on location
def getTrendingSearches():
    toSearch = []
    response = api.trends_place(WOEID)
    trendsDict = response[0]
    trends = trendsDict['trends']

    for trend in trends:
        toSearch.append(trend['name'])

    return toSearch

#gets the trending tweets by searching trending names based on location
def searchAndAnalyze():

    #list to store the popular tweets
    allTweets = []

    #get the names to search
    toSearch = getTrendingSearches()

    #indicates if an error was thrown
    exceptionFlag = False

    #search for each trending names and append json format of each tweet
    #cache our data into a external file to retrieve later
    for searchQuery in toSearch:
        #dictionary with two keys: trends and tweets
        topicDict = {}
        topicDict['trend'] = searchQuery
        searchQueryResult = []
        #try to query
        try:
            #perform the query on the trend
            response = tweepy.Cursor(api.search, q = searchQuery).items(MAX_TWEETS)

            #query each object received from the response
            for object in response:
                searchQueryResult.append(object._json)

            #encapsulate the topic and its list of search results in a dictionary
            topicDict['tweets'] = searchQueryResult

            #append the dictionary to the return list
            allTweets.append(topicDict)


        #catch any errors
        except tweepy.TweepError as e:
            print(e)
            try:
                with open('data.txt') as readfile:
                    if(os.stat('data.txt').st_size == 0):
                        print('data.txt is empty')
                    else:
                        allTweets = json.load(readfile)
                        print('loading cached file')
                        print(len(allTweets))

            except Exception as e:
                print('file does not exist!')
                print(e)

            exceptionFlag = True

        #break out of the loop since we already have an exception
        if(exceptionFlag == True): break

    #no exception means we can just dump our tweets into our file
    if(exceptionFlag == False):
        print('Dumping to file...')
        try:
            print('Opening file...')
            print('Analyzing the tweets')

            #analyze the the tweets
            allTweets = analyzeTweets(allTweets)

            with open('data.txt', 'w') as outfile:
                print('Writing data to file')
                data = json.dumps(allTweets)
                outfile.write(data)
        except Exception as e:
            print('Failed to open file')
            print(e)

    return allTweets



#analyzes the polarity and subjectivity of each tweet
#takes in a list of dictionaries
def analyzeTweets(allTweets):

    #add the text analysis to the dictionary
    for dict in allTweets:
        tweets = dict['tweets']
        for tweet in tweets:
            blob = TextBlob(tweet['text'])
            polarity = blob.polarity
            subjectivity = blob.subjectivity
            tweet['polarity'] = polarity
            tweet['subjectivity'] = subjectivity

    #     for tweet in tweets:
    #         print(tweet['text'])
    #         print(tweet['polarity'])
    #         print(tweet['subjectivity'])
    #
    # print(len(allTweets))
    return allTweets


