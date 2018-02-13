////
//  DetailsTweetController.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/11/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class DetailsTweetController: UIViewController {


    
    @IBOutlet weak var profilePicture: UIImageView!{
        didSet{
            profilePicture.layer.cornerRadius = 3
            //clip the bitmap the imageview contains
            profilePicture.clipsToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favoritesClicked = false;
    
    var tweet: Tweet!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //setup the UI on the view
    func loadUI(){
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.00, green:0.57, blue:1.00, alpha:1.0)
        self.userNameLabel.text = tweet.userName
        self.screenNameLabel.text = tweet.screenName
        self.tweetTextLabel.text = tweet.text!
        let profileUrlString = tweet.profileImageUrl
        let profileUrl = URL(string: profileUrlString!)
        self.profilePicture.setImageWith(profileUrl!)
        
        
        let date = tweet.timeStamp!
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/d/YY, h:mm a"
        let timestamp = formatter.string(from: date)

        self.timeStampLabel.text = "\(timestamp)"
        
        self.favoritesCountLabel.text = "\(tweet.favoritesCount)"
        self.retweetsCountLabel.text = "\(tweet.retweetCount)"
        
        
    }
    
    
    @IBAction func onFavoriteClicked(_ sender: Any) {
        
        //var favoritesCount = tweet.favoritesCount
        if(favoritesClicked == false){
            tweet.favoritesCount += 1
            favoritesClicked = true
        } else{
            tweet.favoritesCount -= 1
            favoritesClicked = false
        }
        
        self.favoritesCountLabel.text = "\(tweet.favoritesCount)"
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
