//
//  TweetsViewController.swift
//  twitter-demo
//
//  Created by Derrick Wong on 2/8/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]!
    var indexPath: IndexPath?
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        self.tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //get the home timeline
        TwitterClient.sharedInstance?.homeTimeLine(success: { (tweets:[Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) in
            print("error getting home timeline")
            print(error.localizedDescription)
        })
        
        setUpNavBar()

        // Do any additional setup after loading the view.
    }
    
    //sets up the custom navigation bar
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tweets != nil{
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        cell.delegate = self
        
        
        return cell
        
    }


    
    //deselects the gray area after user pushes on the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //deselect of the gray cell
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    
    
    @IBAction func onLogOutButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.logout()
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check if sender identifier is requesting to see the detailed tweet.
        if(segue.identifier == "viewDetailedTweet"){
            //get the tweet associated with the current cell
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[indexPath!.row]
            
            let detailViewController = segue.destination as! DetailsTweetController
            
            //pass the tweet
            detailViewController.tweet = tweet
            
        }

        
    }
    


}

extension TweetsViewController: TweetCellDelegate{
    func profileImageTapped(cell: TweetCell, user: NSDictionary) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
            profileVC.user = user //set the profile user before your push
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}


