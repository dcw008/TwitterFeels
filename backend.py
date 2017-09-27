from flask import Flask, jsonify, make_response, abort
import twitter_extension
app = Flask(__name__)
import json
import os
import tweepy
#variable to store the tweets

# tasks = [
#     {
#         'id': 1,
#         'title': u'Buy groceries',
#         'description': u'Milk, Cheese, Pizza, Fruit, Tylenol',
#         'done': False
#     },
#     {
#         'id': 2,
#         'title': u'Learn Python',
#         'description': u'Need to find a good Python tutorial on the web',
#         'done': False
#     }
# ]


#try to modify tweets. if there is an exception, don't modify and just use whatever was stored
@app.route('/twitter_sentiments/api/v1.0/trending', methods=['GET'])
def get_tasks():
    tweets = twitter_extension.analyzeTweets(twitter_extension.getTrendingTweets())

    return jsonify({'tweets': tweets})


if __name__ == '__main__':
    app.run(debug=True)