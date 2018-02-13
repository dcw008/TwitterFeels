//
//  ProfileViewController.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/18/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!{
        didSet{
            profilePicture.layer.cornerRadius = 3
            //clip the bitmap the imageview contains
            profilePicture.clipsToBounds = true
        }
    }
    @IBOutlet weak var profileBanner: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var tweetsLabel: UILabel!
    var user: NSDictionary?
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(user)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        self.tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //get the home timeline
        let screenName = user!["screen_name"] as! String
        print(screenName)
        TwitterClient.userTimeline(screen_name: screenName, success: { (tweets:[Tweet]) in
            
            self.tweets = tweets
            
            
            self.tableView.reloadData()
            for tweet in tweets{
                print(tweet.text)
            }
            
            
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        setUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil{
            return tweets.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
        
    }
    
    

    @IBAction func onBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func setUI(){
        //set the profile picture
        let profilePictureUrlString = user?["profile_image_url"] as? String
        let profilePictureUrl = URL(string: profilePictureUrlString!)
        profilePicture.setImageWith(profilePictureUrl!)
        
        
        
        //set the profile banner
        let profileBannerUrlString = user?["profile_banner_url"] as? String
        
        if profileBannerUrlString != nil {
            let profileBannerUrl = URL(string: profileBannerUrlString!)
            profileBanner.setImageWith(profileBannerUrl!)
            
            //blur the profile banner
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = profileBanner.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            profileBanner.addSubview(blurEffectView)
        }
        
        
        //set screen name
        let screenName = user!["screen_name"] as! String
        self.screenName.text = "@\(screenName)"
        
        userName.text = user!["name"] as? String
        
        //set tweets label
        let status_count = user!["statuses_count"]!
        self.tweetsLabel.text = "\(status_count)"
        
        //set following label
        let follower_count = user!["followers_count"]!
        self.followingLabel.text = "\(follower_count)"
        
        //set followers label
        let friend_count = user!["friends_count"]!
        self.followersLabel.text = "\(friend_count)"
        
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //deselect of the gray cell
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //get the tweet associated with the current cell
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let tweet = tweets[indexPath!.row]
        
        let detailViewController = segue.destination as! DetailsTweetController
        
        
        //pass the tweet
        detailViewController.tweet = tweet
    }
 

}
