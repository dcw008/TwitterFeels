//
//  TwitterClient.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/4/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    
    static let oAuthBaseUrl = "https://api.twitter.com"
    static let sendTweetEndPoint = TwitterClient.oAuthBaseUrl + "/1.1/statuses/update.json?status="
    static let retweetEndpoint = TwitterClient.oAuthBaseUrl + "/1.1/statuses/retweet/"
    static let unretweetEndpoint = TwitterClient.oAuthBaseUrl + "/1.1/statuses/unretweet/"
    static let favoriteEndpoint = "https://api.twitter.com/1.1/favorites/create.json?id="
    static let unfavoriteEndpoint = "https://api.twitter.com/1.1/favorites/destroy.json?id="
    static let userTimelineEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
    
    var loginSuccess: (()->())?
    var loginFailure: ((Error)->())?
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "mWMxbbR2PFmUE1Bk9WV0l1NPK", consumerSecret: "DnSsn308le2mQK7UsKNrTMrXb8p6WlskBd0Otalpgtp933QIgI")
    
    
    func logIn(success: @escaping () -> (), failure: @escaping  (Error) -> () ){
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            //print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            
            
            UIApplication.shared.openURL(url as URL)
        }, failure: { (error: Error?) -> Void in
            print("error \(error!.localizedDescription)")
            self.loginFailure!(error!)
        })

    }
    
    func handleOpenUrl(url: URL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) in
                //call the setter and save to disk
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
            
        }) { (error: Error?) -> Void in
            self.loginFailure?(error!)
        }

    }
    
    func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()){
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            
            success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
                            
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
        })
    }
    
    class func userTimeline(screen_name: String, success: @escaping ([Tweet]) -> (), failure: @escaping(Error) -> ()){
        let url = self.userTimelineEndpoint + "?" + "screen_name=" + screen_name  
        TwitterClient.sharedInstance?.get(url, parameters: nil, progress: nil,
            
            success: { (task: URLSessionDataTask, response: Any?) in
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                success(tweets)
                
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
        })
            
    }
    
    

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //print("account \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            failure(error)
        })

    }

    
    class func sendTweet(text: String, callBack: @escaping (_ response: Tweet?, _ error: Error? ) -> Void){
        
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            callBack(nil, nil)
            return
        }
        let urlString = TwitterClient.sendTweetEndPoint + encodedText
        let _ = TwitterClient.sharedInstance?.post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            if let tweetDict = response as? [String: Any]{
                let tweet = Tweet(dictionary: tweetDict as NSDictionary) //make sure you have your Tweet model ready, and its initializer should take a dictionary as the parameter
                callBack(tweet, nil)
            }else{
                callBack(nil, nil)
            }
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    
    class func retweet(id: String, callBack: @escaping (_ response: Tweet?, _ error: Error?) -> Void){
        let retweetEndpoint = self.retweetEndpoint + id + ".json"
        TwitterClient.sharedInstance?.post(retweetEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweetDict = response as? [String: Any]{
                var tweet: Tweet?
                if let originalTweetDict = tweetDict["retweeted_status"] as? [String: Any]{
                    tweet = Tweet(dictionary: originalTweetDict as NSDictionary)
                }
                
                print("retweet success")
                callBack(tweet, nil)
            } else {
                callBack(nil, nil)
            }
            
        
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            callBack(nil, error)
            
        })
    }
    
    class func unretweet(id: String, callBack: @escaping (_ response: Tweet?, _ error: Error?) -> Void){
        let unRetweetEndpoint = self.unretweetEndpoint + id + ".json"
        TwitterClient.sharedInstance?.post(unRetweetEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweetDict = response as? [String: Any]{
                var tweet: Tweet?
                if let originalTweetDict = tweetDict["retweeted_status"] as? [String: Any]{
                    tweet = Tweet(dictionary: originalTweetDict as NSDictionary)
                }
                
                print("unretweet success")
                callBack(tweet, nil)
            } else {
                callBack(nil, nil)
            }
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error.localizedDescription)
            callBack(nil, error)
            
        })
    }
    
    class func favorite(id: String, success: @escaping () -> (), failure: @escaping (Error) -> () ){
        let favoriteEndPoint = self.favoriteEndpoint  + id
        TwitterClient.sharedInstance?.post(favoriteEndPoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response:Any?) in
            
            success()
            
            print("favorite success")
        }, failure: { (task: URLSessionDataTask?, error:Error) in
            failure(error)
        })
    }
    
    
    class func unfavorite(id:String, success: @escaping () -> (), failure: @escaping (Error) -> () ){
        let unfavoriteEndpoint = self.unfavoriteEndpoint + id
        TwitterClient.sharedInstance?.post(unfavoriteEndpoint, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
            print("unfavorite success")
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
        
    }
    func logout(){
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogutNotification), object: nil )
    }
    

}
