//
//  Tweet.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/4/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit


class Tweet: NSObject {
    var user: NSDictionary?
    var userName: String?
    var screenName: String?
    var profileImageUrl: String?
    var text: String?
    var timeStamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var tweetID: String?
    
    //tweet constructor
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        user = dictionary["user"] as? NSDictionary
        screenName = "@\(user!["screen_name"] as! String)"
        profileImageUrl = user!["profile_image_url_https"] as? String
        userName = user!["name"] as? String
        tweetID = dictionary["id_str"] as? String
        
        let timeStampString = dictionary["created_at"] as? String
        
        
        if let timeStampString = timeStampString{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Zy"
            timeStamp = formatter.date(from: timeStampString)!
        }
        
        
        
        
    }
    
    override init(){
        
        text = ""
        retweetCount = 0
        favoritesCount = 0

    }
    
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        //array of tweets
        var tweets = [Tweet]()
        
        //iterate through all dictionaries and create a tweet based on the dictionary and then add it back to the array
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        //return the array
        return tweets
        
    }
}
