//
//  TweetsViewControllerNavBarExtension.swift
//  twitter-demo
//
//  Created by Derrick Wong on 9/14/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//
import UIKit
import Foundation

extension TweetsViewController{
    func setUpNavBar(){
        setTitle()
        setCompose()
        setBarColor()
    }
    
    private func setTitle(){
        // set the title image
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "title_icon"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }
    
    private func setCompose(){
        //set the compose tweet button
        let composeButton = UIButton(type: .system)
        composeButton.setImage(#imageLiteral(resourceName: "compose").withRenderingMode(.alwaysOriginal), for: .normal)
        
        composeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        composeButton.addTarget(self, action: Selector("composeTweetSegue"), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: composeButton)
    }
    
    private func setBarColor(){
        //make navigation bar white
        //navigationController?.navigationBar.backgroundColor = .white
        //navigationController?.navigationBar.isTranslucent = false
        
    }
    
    
    //segue to the composeTweet view embedded inside a navigation controller
    func composeTweetSegue(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let composeVC = storyboard.instantiateViewController(withIdentifier: "CreateTweetViewController") as! CreateTweetViewController
        let navController = UINavigationController(rootViewController: composeVC)
        
        navigationController?.present(navController, animated: true, completion: nil)
        
        
    }


}
