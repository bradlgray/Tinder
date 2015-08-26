//
//  SwipingViewController.swift
//  ParseStarterProject
//
//  Created by Brad Gray on 8/25/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class SwipingViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var userInfo: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      var query = PFUser.query()!
        var interestedIn = "male"
        
        if PFUser.currentUser()!["interestedInWomen"]! as! Bool == true {
            interestedIn = "female"
            
        }
        
        var isFemale = true
        
        if PFUser.currentUser()?["gender"]! as! String == "male" {
            isFemale = false
        }
        query.whereKey("gender", equalTo: interestedIn)
        query.whereKey("interestedInWomen", equalTo: isFemale)
        query.limit = 1
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print(error)
            } else if let objects = objects as? [PFObject] {
                
                for object in objects {
                    print(object)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logOut" {
            PFUser.logOut()
        }
    }

    }
