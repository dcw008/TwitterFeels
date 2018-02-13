//
//  TweetCell.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/8/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
    func profileImageTapped(cell: TweetCell, user: NSDictionary)
    
}



class TweetCell: UITableViewCell {
    
    var indexPath: IndexPath?
    weak var delegate: TweetCellDelegate?
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    

   
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var hasRetweeted = false
    var hasFavorited = false

    
    var tweet: Tweet?{
        
        didSet{
            if let tweet = tweet{
                self.userName.text = tweet.userName!
                self.screenName.text = tweet.screenName!
                
                self.tweetText.text = tweet.text!
                let imageUrlString = tweet.profileImageUrl
                let imageUrl = URL(string: imageUrlString!)
                self.profilePicture.setImageWith(imageUrl!)
                
                
                let date = tweet.timeStamp!
                //gives the time difference between system time in seconds
                let difference = Int(Date().timeIntervalSince(date))
                let new_diff = convertDifference(difference: difference)
                
                
                self.timeStamp.text = "\(new_diff)"
//                let formatter = DateFormatter()
//                formatter.dateFormat = "d MMM YY"
//                let timestamp = formatter.string(from: date)
//              
//                self.timeStamp.text = "\(timestamp)"
//                
                self.retweetCountLabel.text = "\(tweet.retweetCount)"
                self.favoriteLabel.text = "\(tweet.favoritesCount)"
                
                self.profilePicture.isUserInteractionEnabled = true //make sure this is enabled
                //tap for userImageView
                let userProfileTap = UITapGestureRecognizer(target: self, action: #selector(userProfileTapped(_:)))
                self.profilePicture.addGestureRecognizer(userProfileTap)

                                
            }
            
        }
    }
    
    func userProfileTapped(_ gesture: UITapGestureRecognizer){
        if let delegate = delegate{
            delegate.profileImageTapped(cell: self, user: (self.tweet?.user)!)
        }
    }
    
   
    
    //converts the difference from seconds into hrs -> days
    func convertDifference(difference: Int) -> String{
        
        var new_diff: Int
        var ret_val: String
        
        //if within an min, leave as seconds
        if(difference < 60){
            ret_val = "\(difference)s"
        }
        
        //if within an hr, convert to minutes
        if(difference < 3600){
            new_diff = (Int) (difference/60)
            ret_val = "\(new_diff)m"
        }
            
        // if within 24 hrs, convert to hrs
        else if (difference < (3600*24)){
            new_diff = (Int) ((difference/60) / 60)
            ret_val = "\(new_diff)hr"
            
        }
        
        // if within a week, convert to days
        else if (difference < (3600*24*7)){
            new_diff = (Int) (((difference/60) / 60) / 24)
            ret_val = "\(new_diff)d"
        }
        
        // if within a month, convert to week
        else if (difference < (3600*24*7*30)){
            new_diff = (Int) ((((difference/60) / 60) / 24) / 7)
            ret_val = "\(new_diff)wk"
            
        }
        
        // if within a year, convert to months
        else if(difference < (3600*24*7*30*12)){
            new_diff = (Int) (((((difference/60) / 60) / 24) / 7) / 30)
            ret_val = "\(new_diff)m"
        }
        
        // convert to years
        else{
            new_diff = (Int) (((((difference/60) / 60) / 24) / 7) / 30) / 12
            ret_val = "\(new_diff)yr"
            
        }
        
        return ret_val
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.layer.cornerRadius = 3
        //clip the bitmap the imageview contains
        profilePicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onFavoritesClicked(_ sender: Any) {
        //print(hasFavorited)
        //print("before:  \(self.favoriteLabel.text)")
        if(hasFavorited == false){
            TwitterClient.favorite(id: (tweet?.tweetID)!, success: {
                
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            self.tweet?.favoritesCount += 1
            self.hasFavorited = true
        } else{
            //api call to unfavorite
            TwitterClient.unfavorite(id: (self.tweet?.tweetID)!, success: { 

            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            
            self.tweet?.favoritesCount -= 1
            self.hasFavorited = false
            
        }
        
        //print("after:  \(self.favoriteLabel.text)")
        self.favoriteLabel.text = "\(self.tweet!.favoritesCount)"
        
       
    }
    
    @IBAction func onRetweetClicked(_ sender: Any) {
        if(hasRetweeted == false){
            TwitterClient.retweet(id: (tweet?.tweetID)!, callBack: { (tweet, error) in
                
            })
            tweet?.retweetCount += 1
            self.hasRetweeted = true
            
        } else{
            TwitterClient.unretweet(id: (tweet?.tweetID)!, callBack: { (tweet, error) in
                
            })
            
            tweet?.retweetCount -= 1
            self.hasRetweeted = false
        }
        self.retweetCountLabel.text = "\(self.tweet!.retweetCount)"
    }

}
